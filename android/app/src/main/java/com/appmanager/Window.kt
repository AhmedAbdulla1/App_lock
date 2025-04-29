package com.example.untitled1

import android.annotation.SuppressLint
import android.content.Context
import android.graphics.PixelFormat
import android.os.Handler
import android.os.Looper
import android.view.*
import android.widget.Button
import android.widget.TextView
import androidx.biometric.BiometricPrompt
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import java.util.concurrent.Executor

@SuppressLint("InflateParams")
class Window(
	private val context: Context
) {
	private val mView: View
	private var mParams: WindowManager.LayoutParams? = null
	private val mWindowManager: WindowManager
	private val layoutInflater: LayoutInflater
	private var txtView: TextView? = null
	private var biometricPrompt: BiometricPrompt? = null
	private lateinit var promptInfo: BiometricPrompt.PromptInfo
	private lateinit var executor: Executor

	fun open() {
		try {
			if (mView.windowToken == null) {
				if (mView.parent == null) {
					mWindowManager.addView(mView, mParams)
				}
			}
		} catch (e: Exception) {
			e.printStackTrace()
		}
	}

	fun isOpen(): Boolean {
		return (mView.windowToken != null && mView.parent != null)
	}

	fun close() {
		try {
			Handler(Looper.getMainLooper()).postDelayed({
				(context.getSystemService(Context.WINDOW_SERVICE) as WindowManager).removeView(mView)
				mView.invalidate()
			}, 500)
		} catch (e: Exception) {
			e.printStackTrace()
		}
	}

	fun setTxtViewVisibility(visibility: Int) {
		txtView?.visibility = visibility
	}

	private fun doneButton(authenticated: Boolean) {
		try {
			if (authenticated) {
				close()
			} else {
				txtView?.visibility = View.VISIBLE
			}
		} catch (e: Exception) {
			println("$e---------------doneButton")
		}
	}

	init {
		mParams = WindowManager.LayoutParams(
			WindowManager.LayoutParams.MATCH_PARENT,
			WindowManager.LayoutParams.MATCH_PARENT,
			WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY,
			WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN,
			PixelFormat.TRANSLUCENT
		)
		layoutInflater = context.getSystemService(Context.LAYOUT_INFLATER_SERVICE) as LayoutInflater
		mView = layoutInflater.inflate(R.layout.biometric_activity, null)
		mParams?.gravity = Gravity.CENTER
		mWindowManager = context.getSystemService(Context.WINDOW_SERVICE) as WindowManager

		txtView = mView.findViewById(R.id.alertError) as TextView
		val authButton = mView.findViewById<Button>(R.id.authButton)

		executor = ContextCompat.getMainExecutor(context)
		if (context is FragmentActivity) {
			biometricPrompt = BiometricPrompt(
				context,
				executor,
				object : BiometricPrompt.AuthenticationCallback() {
					override fun onAuthenticationError(errorCode: Int, errString: CharSequence) {
						super.onAuthenticationError(errorCode, errString)
						doneButton(false)
					}

					override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
						super.onAuthenticationSucceeded(result)
						doneButton(true)
					}

					override fun onAuthenticationFailed() {
						super.onAuthenticationFailed()
						doneButton(false)
					}
				})
			promptInfo = BiometricPrompt.PromptInfo.Builder()
				.setTitle("Unlock App")
				.setDescription("Use Face ID to unlock the app")
				.setNegativeButtonText("Cancel")
				.build()

			authButton.setOnClickListener {
				txtView?.visibility = View.INVISIBLE
				biometricPrompt?.authenticate(promptInfo)
			}
		} else {
			// Fallback for non-FragmentActivity context
			authButton.setOnClickListener {
				txtView?.visibility = View.VISIBLE
				txtView?.text = "Face ID not supported in this context"
			}
		}
	}
}