package com.example.test_ar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.net.Uri
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.HomeWidgetPlugin

/**
 * Implementation of App Widget functionality.
 */
class HomeWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.home_widget).apply {
                val textFromFlutter = widgetData.getString("text_from_flutter_app", null)
                setTextViewText(
                    R.id.text_id, textFromFlutter ?: "No title set"
                )
//                val incrementIntent = HomeWidgetBackgroundIntent.getBroadcast(
//                    context, Uri.parse("myAppWidget://increment")
//                )
//                val clearIntent = HomeWidgetBackgroundIntent.getBroadcast(
//                    context, Uri.parse("myAppWidget://clear")
//                )
//                setOnClickPendingIntent(R.id.button_increment, incrementIntent)
//                setOnClickPendingIntent(R.id.button_clear, clearIntent)

            }
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }


}

internal fun updateAppWidget(
    context: Context, appWidgetManager: AppWidgetManager, appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.home_widget)
    views.setTextViewText(R.id.text_id, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}