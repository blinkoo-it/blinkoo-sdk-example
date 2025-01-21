package com.blinkoo.blinkoo_components_example

import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.wrapContentSize
import androidx.compose.material3.Button
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.unit.dp
import androidx.compose.ui.viewinterop.AndroidView
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.lifecycleScope
import com.blinkoo.blinkoo_components_example.ui.theme.BlinkooComponentsExampleTheme
import com.blinkoo.sdk.feed.BlinkooFeedComponent
import com.blinkoo.sdk.feed.model.BlinkooFeedArgs
import kotlinx.coroutines.launch

class MainActivity : FragmentActivity() {
    val tag = this.javaClass.name
    val apiKey = "API_KEY"
    override fun onCreate(savedInstanceState: Bundle?) {
        val feed = BlinkooFeedComponent(
            this,
            apiKey
        )
        super.onCreate(savedInstanceState)
        setContent {
            val context = LocalContext.current
            val activity = context as? FragmentActivity // Explicit cast to FragmentActivity
            val fragmentManager = activity?.supportFragmentManager
            val fragmentContainerId = View.generateViewId() // Generate unique ID

            val frameLayout = FrameLayout(context).apply {
                id = fragmentContainerId
                layoutParams = ViewGroup.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT,
                    ViewGroup.LayoutParams.MATCH_PARENT
                )
            }

            BlinkooComponentsExampleTheme {
                Scaffold { padding ->
                    Column(
                        modifier = Modifier
                            .fillMaxSize()
                            .padding(padding),
                        horizontalAlignment = Alignment.CenterHorizontally
                    ) {
                        // Button to start the Activity
                        Button(
                            modifier = Modifier
                                .wrapContentSize()
                                .padding(16.dp),
                            onClick = {
                                lifecycleScope.launch {
                                    feed.startActivity(BlinkooFeedArgs())
                                }
                            }
                        ) {
                            Text("Start feed activity")
                        }

                        // Button to start the Fragment
                        Button(
                            modifier = Modifier
                                .wrapContentSize()
                                .padding(16.dp),
                            onClick = {
                                fragmentManager?.let {
                                    lifecycleScope.launch {
                                        feed.startFragment(
                                            it,
                                            fragmentContainerId,
                                            BlinkooFeedArgs()
                                        )
                                    }
                                } ?: Log.e(tag, "FragmentManager not available")
                            }
                        ) {
                            Text("Start feed fragment")
                        }

                        // Button to close the Fragment
                        Button(
                            modifier = Modifier
                                .wrapContentSize()
                                .padding(16.dp),
                            onClick = {
                                fragmentManager?.let {
                                    feed.closeFragment(fragmentManager, fragmentContainerId)
                                }
                            }
                        ) {
                            Text("Close feed fragment")
                        }

                        // Layout to host the Fragment
                        AndroidView(
                            factory = { context ->
                                frameLayout
                            },
                            modifier = Modifier
                                .fillMaxWidth()
                                .weight(1f) // Takes up remaining space
                        )
                    }
                }
            }
        }
    }
}