class DiscountState {
  static bool descuentoActivo = false;

  static void activar() {
    descuentoActivo = true;
  }

  static void desactivar() {
    descuentoActivo = false;
  }
}
