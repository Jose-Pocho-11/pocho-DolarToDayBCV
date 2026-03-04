package com.example.dolar // Reemplaza con el paquete exacto que sale al inicio de tu MainActivity.kt

import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.SharedPreferences
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetProvider

class DolarWidgetProvider : HomeWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray,
        widgetData: SharedPreferences
    ) {
        for (appWidgetId in appWidgetIds) {
            // Buscamos el XML que creamos en el Paso 3
            val views = RemoteViews(context.packageName, R.layout.dolar_widget)
            
            // Leemos el precio que guardó Flutter
            val precio = widgetData.getString("precio_oficial", "---")
            
            // Inyectamos el precio en el TextView
            views.setTextViewText(R.id.widget_precio_texto, precio)

            // Refrescamos
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}