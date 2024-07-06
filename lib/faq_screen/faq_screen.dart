import 'package:flutter/material.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'FAQ',
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: ListView.builder(
        itemCount: faqData.length,
        itemBuilder: (BuildContext context, int index) {
          return Theme(
            data: Theme.of(context).copyWith(
              dividerColor:
                  Colors.transparent, // Set divider color to transparent
            ),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
              child: ExpansionTile(
                title: Text(faqData[index]['question']!),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      faqData[index]['answer']!,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

List<Map<String, String>> faqData = [
  {
    'question': 'What is your return policy?',
    'answer': 'We accept returns within 30 days of purchase.'
  },
  {
    'question': 'Do you offer free Delivery?',
    'answer': 'Yes, we offer free Delivery on orders over 100 AED.'
  },
  {
    'question': 'How can I track my order?',
    'answer':
        'You can track your order using the tracking number provided in your Delivery confirmation email.'
  },
  {
    'question': 'What payment methods do you accept?',
    'answer': 'We accept credit/debit cards, PayPal, and Apple Pay.'
  },

  {
    'question': 'Can I cancel or modify my order after it has been placed?',
    'answer':
        'Please contact our customer service team as soon as possible if you need to cancel or modify your order.'
  },
  {
    'question': 'Is your website secure and safe to use?',
    'answer':
        'Yes, our website uses industry-standard encryption to protect your personal and financial information.'
  },
  {
    'question': 'Do you have a physical store or showroom that I can visit?',
    'answer': 'No, we are an online-only retailer at this time.'
  },
  {
    'question': 'How long will it take for my order to arrive?',
    'answer':
        'Standard Delivery typically takes 5-7 business days, but may vary depending on your location.'
  },

  // Add more FAQ data as needed
];
