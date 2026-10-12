package com.ol1n.puff

import android.app.Application
import com.google.android.gms.games.PlayGamesSdk

class PuffApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        // Play Games v2 has to be initialised before the first activity, and
        // games_services does not do it. Skipped while games-ids.xml is still
        // empty, so a build without a Play Games project starts as before.
        if (getString(R.string.game_services_project_id).isNotEmpty()) {
            PlayGamesSdk.initialize(this)
        }
    }
}
