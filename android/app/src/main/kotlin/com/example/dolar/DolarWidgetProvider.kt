package com.example.dolar

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class DolarWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val views = RemoteViews(context.packageName, R.layout.dolar_widget)
    
    // Obtener el precio guardado usando HomeWidget
    val precio = try {
        HomeWidgetPlugin.getData(context)
            .getString("precio_oficial", "Cargando...")
    } catch (e: Exception) {
        // Si HomeWidget falla, intentar con SharedPreferences
        val sharedPrefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE)
        sharedPrefs.getString("flutter.precio_oficial", "Cargando...") ?: "Cargando..."
    }
    
    views.setTextViewText(R.id.widget_precio_texto, "Bs: $precio")
    
    appWidgetManager.updateAppWidget(appWidgetId, views)
}
