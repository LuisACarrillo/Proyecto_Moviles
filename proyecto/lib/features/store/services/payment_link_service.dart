import 'package:url_launcher/url_launcher.dart';

class PaymentLinkService {
  static const String stripePaymentLink =
      "https://buy.stripe.com/test_aFaeV5csw4Hb4UQ75t6Na00";

  static Future<void> openStripeCheckout() async {
    final uri = Uri.parse(stripePaymentLink);

    final success = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!success) {
      throw Exception("No se pudo abrir el enlace de Stripe");
    }
  }
}
