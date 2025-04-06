import 'package:client/features/contacts/models/contact.dart';
import 'package:flutter/material.dart';

class ContactListItem extends StatelessWidget {
  final Contact contact;

  const ContactListItem({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: CircleAvatar(
        backgroundColor: colorScheme.primaryContainer,
        child: Text(
          contact.firstName?.isNotEmpty == true
              ? contact.firstName![0].toUpperCase()
              : contact.lastName?.isNotEmpty == true
              ? contact.lastName![0].toUpperCase()
              : contact.email.isNotEmpty == true
              ? contact.email[0].toUpperCase()
              : '?',
          style: TextStyle(color: colorScheme.onPrimaryContainer),
        ),
      ),
      title: Text(contact.fullName, style: textTheme.titleMedium), // Use fullName getter
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(contact.email),
          if (contact.companyName != 'Unknown Company') // Use companyName getter
            Text(contact.companyName, style: textTheme.bodySmall),
          if (contact.cellphoneNumber != null) Text('Cell: ${contact.cellphoneNumber}', style: textTheme.bodySmall),
          if (contact.officePhoneNumber != null)
            Text('Office: ${contact.officePhoneNumber}', style: textTheme.bodySmall),
        ],
      ),
      isThreeLine:
          (contact.cellphoneNumber != null ||
              contact.officePhoneNumber != null ||
              contact.companyName != 'Unknown Company'), // Adjust based on content
      // Add onTap for navigation or actions if needed
      // onTap: () {
      //   // Navigate to contact details page, etc.
      // },
    );
  }
}
