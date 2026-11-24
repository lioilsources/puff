// Babylon view of the world: orthographic camera in meters (Forge2D y down → mesh y = -y),
// neon outlines as thin triangle strips with a glow layer, like the Flutter stroke + bloom.
import { Camera } from '@babylonjs/core/Cameras/camera';
import { FreeCamera } from '@babylonjs/core/Cameras/freeCamera';
import type { Engine } from '@babylonjs/core/Engines/engine';
import { GlowLayer } from '@babylonjs/core/Layers/glowLayer';
import { StandardMaterial } from '@babylonjs/core/Materials/standardMaterial';
import { Color3, Color4 } from '@babylonjs/core/Maths/math.color';
import { Vector3 } from '@babylonjs/core/Maths/math.vector';
import { Mesh } from '@babylonjs/core/Meshes/mesh';
import { VertexData } from '@babylonjs/core/Meshes/mesh.vertexData';
import { Scene } from '@babylonjs/core/scene';
import { vertices, type ShapeSpec } from '../rules/shapes';
import { tuning as T } from '../rules/tuning';
import type { Vec } from '../rules/vec';
import { PALETTES } from '../ui/generated/palette';

export type Palette = (typeof PALETTES)[keyof typeof PALETTES];
type Role = 'primary' | 'secondary' | 'accent' | 'glow' | 'hazard';

const rgb = (argb: number): Color3 => new Color3(((argb >> 16) & 255) / 255, ((argb >> 8) & 255) / 255, (argb & 255) / 255);

const roleOf = (s: ShapeSpec): Role =>
  s.kind === 'tri' ? 'primary' : s.kind === 'square' ? 'secondary' : s.kind === 'poly' ? 'accent' : 'glow';

/** Closed outline → a strip of quads [width] wide, centred on the path. */
function strip(points: readonly Vec[], width: number): VertexData {
  const pos: number[] = [];
  const idx: number[] = [];
  const n = points.length;
  for (let i = 0; i < n; i++) {
    const a = points[(i + n - 1) % n];
    const b = points[i];
    const c = points[(i + 1) % n];
    // Miter direction: average of the two edge normals.
    const n1 = norm(b.y - a.y, -(b.x - a.x));
    const n2 = norm(c.y - b.y, -(c.x - b.x));
    const m = norm(n1.x + n2.x, n1.y + n2.y);
    const k = width / 2 / Math.max(0.3, m.x * n2.x + m.y * n2.y);
    pos.push(b.x + m.x * k, -(b.y + m.y * k), 0, b.x - m.x * k, -(b.y - m.y * k), 0);
    const j = i * 2;
    const nj = ((i + 1) % n) * 2;
    idx.push(j, nj, j + 1, j + 1, nj, nj + 1);
  }
  const vd = new VertexData();
  vd.positions = pos;
  vd.indices = idx;
  return vd;
}

function norm(x: number, y: number): Vec {
  const l = Math.hypot(x, y) || 1;
  return { x: x / l, y: y / l };
}

const ring = (r: number, segments = 40): Vec[] =>
  Array.from({ length: segments }, (_, i) => ({ x: Math.cos((i / segments) * Math.PI * 2) * r, y: Math.sin((i / segments) * Math.PI * 2) * r }));

export class PuffScene {
  readonly scene: Scene;
  private readonly camera: FreeCamera;
  private readonly mats = new Map<string, StandardMaterial>();
  readonly cloud: Mesh;
  readonly cloudFill: Mesh;
  readonly core: Mesh;
  /** Visible world in meters (width fixed, height follows the screen). */
  world = { x: T.worldWidth, y: T.worldWidth * 2 };

  constructor(engine: Engine, readonly palette: Palette) {
    const scene = new Scene(engine);
    this.scene = scene;
    const bg = rgb(palette.bg);
    scene.clearColor = new Color4(bg.r, bg.g, bg.b, 1);
    this.camera = new FreeCamera('cam', new Vector3(0, 0, -10), scene);
    this.camera.mode = Camera.ORTHOGRAPHIC_CAMERA;
    this.camera.setTarget(Vector3.Zero());
    const glow = new GlowLayer('glow', scene, { mainTextureRatio: 0.5, blurKernelSize: 32 });
    glow.intensity = 0.9;

    this.core = this.outline('core', ring(T.coreRadius), 0.06, 'hazard');
    this.cloud = this.outline('cloud', ring(1), 0.04, 'glow');
    this.cloudFill = new Mesh('cloudFill', scene);
    const disk = new VertexData();
    const r = ring(1, 40);
    disk.positions = [0, 0, 0.01, ...r.flatMap((p) => [p.x, -p.y, 0.01])];
    disk.indices = r.flatMap((_, i) => [0, 1 + i, 1 + ((i + 1) % r.length)]);
    disk.applyToMesh(this.cloudFill);
    const fill = new StandardMaterial('cloudFillMat', scene);
    fill.disableLighting = true;
    fill.emissiveColor = rgb(palette.glow);
    fill.alpha = 0.18;
    this.cloudFill.material = fill;
    this.setCloud(null, 0);
  }

  private material(role: Role, alpha = 1): StandardMaterial {
    const key = `${role}/${alpha}`;
    let m = this.mats.get(key);
    if (!m) {
      m = new StandardMaterial(key, this.scene);
      m.disableLighting = true;
      m.emissiveColor = rgb(this.palette[role]);
      m.alpha = alpha;
      m.backFaceCulling = false;
      this.mats.set(key, m);
    }
    return m;
  }

  private outline(name: string, points: readonly Vec[], width: number, role: Role): Mesh {
    const mesh = new Mesh(name, this.scene);
    strip(points, width).applyToMesh(mesh);
    mesh.material = this.material(role);
    return mesh;
  }

  /** One mesh per body; metal shapes get the inset second outline as a child. */
  shapeMesh(spec: ShapeSpec): Mesh {
    const pts = spec.kind === 'circle' ? ring(spec.size, 28) : vertices(spec);
    const mesh = this.outline('shape', pts, T.strokeWidth, roleOf(spec));
    if (spec.material === 'metal') {
      const inner = this.outline('inner', pts.map((p) => ({ x: p.x * 0.62, y: p.y * 0.62 })), T.strokeWidth * 0.6, roleOf(spec));
      inner.material = this.material(roleOf(spec), 0.7);
      inner.parent = mesh;
    }
    return mesh;
  }

  place(mesh: Mesh, p: Vec, angle: number): void {
    mesh.position.set(p.x, -p.y, 0);
    mesh.rotation.z = -angle;
  }

  setCloud(p: Vec | null, radius: number): void {
    const on = p !== null;
    this.cloud.setEnabled(on);
    this.cloudFill.setEnabled(on);
    if (!p) return;
    for (const m of [this.cloud, this.cloudFill]) {
      m.position.set(p.x, -p.y, 0);
      m.scaling.set(radius, radius, 1);
    }
  }

  /** Width is fixed at worldWidth meters; height follows the canvas. */
  fit(width: number, height: number): void {
    const w = T.worldWidth;
    const h = (w * height) / width;
    this.world = { x: w, y: h };
    const c = this.camera;
    c.orthoLeft = -w / 2;
    c.orthoRight = w / 2;
    c.orthoTop = h / 2;
    c.orthoBottom = -h / 2;
  }

  /** Screen pixel → world meters (y down). */
  toWorld(px: number, py: number, width: number, height: number): Vec {
    return { x: (px / width - 0.5) * this.world.x, y: (py / height - 0.5) * this.world.y };
  }
}
