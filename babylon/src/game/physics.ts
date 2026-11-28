// Forge2D → planck.js. Both are Box2D ports with the same units (meters, kg, y down here as in
// the Flutter world), so bodies, fixtures, damping and impulses map one to one.
import { Circle, Polygon, Vec2, World, type Body } from 'planck';
import { type ShapeSpec, vertices } from '../rules/shapes';
import type { Environment } from '../rules/tuning';
import type { Vec } from '../rules/vec';

export interface ShapeData {
  kind: 'shape';
  spec: ShapeSpec;
  generation: number;
  maxDepth: number | null;
  hitFlash: number;
  pendingFracture: Vec | null;
  dead: boolean;
}

export interface CoreData {
  kind: 'core';
}

export type BodyData = ShapeData | CoreData;

export function createWorld(env: Environment): World {
  return new World({ gravity: Vec2(0, env.gravityY) });
}

export function addShape(world: World, env: Environment, spec: ShapeSpec, p: Vec, v: Vec, angle: number, w: number, generation = 0, maxDepth: number | null = null): Body {
  const body = world.createBody({
    type: 'dynamic',
    position: Vec2(p.x, p.y),
    angle,
    linearVelocity: Vec2(v.x, v.y),
    angularVelocity: w,
    linearDamping: env.linearDamping,
    angularDamping: env.angularDamping,
    bullet: false,
  });
  const shape = spec.kind === 'circle' ? new Circle(spec.size) : new Polygon(vertices(spec).map((q) => Vec2(q.x, q.y)));
  body.createFixture({ shape, density: spec.density, restitution: spec.restitution, friction: spec.friction });
  const data: ShapeData = { kind: 'shape', spec, generation, maxDepth, hitFlash: 0, pendingFracture: null, dead: false };
  body.setUserData(data);
  return body;
}

export function addCore(world: World, radius: number): Body {
  const body = world.createBody({ type: 'kinematic', position: Vec2(0, 0) });
  body.createFixture({ shape: new Circle(radius), isSensor: true });
  body.setUserData({ kind: 'core' } satisfies CoreData);
  return body;
}

export const dataOf = (b: Body): BodyData | undefined => b.getUserData() as BodyData | undefined;
