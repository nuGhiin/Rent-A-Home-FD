import 'package:flutter/cupertino.dart';
import 'package:flutter_easy_faq/flutter_easy_faq.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            EasyFaq(question: "What types of rental properties are available on your platform?",
                answer: "Our platform offers a variety of rental properties including apartments, houses, villas, and studio flats suitable for both families and individuals"),
            SizedBox(height: 10,),
            EasyFaq(question: "Can I view the property before renting it?",
                answer: " Yes, you can schedule a viewing for any property you are interested in renting. Simply contact the property owner or agent through our platform to arrange a viewing."),
            SizedBox(height: 10,),
            EasyFaq(question: "What is the typical rental process like?",
                answer: "The rental process involves browsing listings, scheduling viewings, submitting rental applications, undergoing background checks, signing the lease agreement, and paying the required deposits and rent."),
            SizedBox(height: 10,),
            EasyFaq(question: "Are utilities included in the rent?",
                answer: " It depends on the individual property listing. Some rental properties include utilities such as water, electricity, and internet in the rent, while others may require tenants to pay for utilities separately."),
            SizedBox(height: 10,),
            EasyFaq(question: "What are the average rental prices in Sylhet?",
                answer: "Rental prices vary depending on the type of property, location, size, and amenities. On our platform, you can find rental properties to suit various budget ranges."),
          ],
        ),
      ),
    );
  }
}
