class DolarResponse {
  final String fuente; 
  final String nombre;
  final double promedio;
  final String fechaActualizacion;

  DolarResponse({required this.promedio, required this.nombre, required this.fechaActualizacion, required this.fuente});
  factory DolarResponse.fromJson(Map<String, dynamic> json) {
    return DolarResponse(
       fuente: json['fuente']??'',
      promedio: (json['promedio']??0.0).toDouble(),
      nombre: json['nombre']??'',
      fechaActualizacion: json['fechaActualizacion']??'',
    );
  }
  @override
  String toString() {
    return '{Nombre: $nombre, Promedio: $promedio, Fuente: $fuente}';
  }
}