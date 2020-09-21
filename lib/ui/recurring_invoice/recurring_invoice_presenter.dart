import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:invoiceninja_flutter/constants.dart';
import 'package:invoiceninja_flutter/data/models/models.dart';
import 'package:invoiceninja_flutter/data/models/recurring_invoice_model.dart';
import 'package:invoiceninja_flutter/redux/app/app_state.dart';
import 'package:invoiceninja_flutter/ui/app/presenters/entity_presenter.dart';
import 'package:invoiceninja_flutter/utils/formatting.dart';
import 'package:invoiceninja_flutter/utils/localization.dart';

class RecurringInvoicePresenter extends EntityPresenter {
  static List<String> getDefaultTableFields(UserCompanyEntity userCompany) {
    return [
      RecurringInvoiceFields.invoiceNumber,
      RecurringInvoiceFields.client,
      RecurringInvoiceFields.amount,
      RecurringInvoiceFields.status,
      RecurringInvoiceFields.remainingCycles,
      RecurringInvoiceFields.nextSendDate,
      RecurringInvoiceFields.frequency,
      RecurringInvoiceFields.dueDateDays,
      RecurringInvoiceFields.autoBill,
    ];
  }

  static List<String> getAllTableFields(UserCompanyEntity userCompany) {
    return [
      ...getDefaultTableFields(userCompany),
      ...EntityPresenter.getBaseFields(),
      RecurringInvoiceFields.discount,
      RecurringInvoiceFields.poNumber,
      RecurringInvoiceFields.publicNotes,
      RecurringInvoiceFields.privateNotes,
      RecurringInvoiceFields.documents,
      RecurringInvoiceFields.customValue1,
      RecurringInvoiceFields.customValue2,
      RecurringInvoiceFields.customValue3,
      RecurringInvoiceFields.customValue4,
      RecurringInvoiceFields.taxAmount,
      RecurringInvoiceFields.exchangeRate,
    ];
  }

  @override
  Widget getField({String field, BuildContext context}) {
    final localization = AppLocalization.of(context);
    final state = StoreProvider.of<AppState>(context).state;
    final invoice = entity as InvoiceEntity;

    switch (field) {
      case RecurringInvoiceFields.status:
        return Text(
          localization
              .lookup(kRecurringInvoiceStatuses[invoice.calculatedStatusId]),
        );
      case RecurringInvoiceFields.invoiceNumber:
        return Text((invoice.number ?? '').isEmpty
            ? localization.pending
            : invoice.number);
      case RecurringInvoiceFields.client:
        return Text((state.clientState.map[invoice.clientId] ??
                ClientEntity(id: invoice.clientId))
            .listDisplayName);
      case RecurringInvoiceFields.date:
        return Text(formatDate(invoice.date, context));
      case RecurringInvoiceFields.reminder1Sent:
        return Text(formatDate(invoice.reminder1Sent, context));
      case RecurringInvoiceFields.reminder2Sent:
        return Text(formatDate(invoice.reminder2Sent, context));
      case RecurringInvoiceFields.reminder3Sent:
        return Text(formatDate(invoice.reminder3Sent, context));
      case RecurringInvoiceFields.reminderLastSent:
        return Text(formatDate(invoice.reminderLastSent, context));
      case RecurringInvoiceFields.amount:
        return Align(
          alignment: Alignment.centerRight,
          child: Text(formatNumber(invoice.amount, context,
              clientId: invoice.clientId)),
        );
      case RecurringInvoiceFields.customValue1:
        return Text(invoice.customValue1);
      case RecurringInvoiceFields.customValue2:
        return Text(invoice.customValue2);
      case RecurringInvoiceFields.customValue3:
        return Text(invoice.customValue3);
      case RecurringInvoiceFields.customValue4:
        return Text(invoice.customValue4);
      case RecurringInvoiceFields.publicNotes:
        return Text(invoice.publicNotes);
      case RecurringInvoiceFields.privateNotes:
        return Text(invoice.privateNotes);
      case RecurringInvoiceFields.discount:
        return Text(invoice.isAmountDiscount
            ? formatNumber(invoice.discount, context,
                formatNumberType: FormatNumberType.money,
                clientId: invoice.clientId)
            : formatNumber(invoice.discount, context,
                formatNumberType: FormatNumberType.percent));
      case RecurringInvoiceFields.poNumber:
        return Text(invoice.poNumber);
      case RecurringInvoiceFields.documents:
        return Text('${invoice.documents.length}');
      case RecurringInvoiceFields.taxAmount:
        return Text(formatNumber(invoice.taxAmount, context,
            clientId: invoice.clientId));
      case RecurringInvoiceFields.exchangeRate:
        return Text(formatNumber(invoice.exchangeRate, context,
            formatNumberType: FormatNumberType.double));
      case RecurringInvoiceFields.remainingCycles:
        return Text(invoice.remainingCycles == -1
            ? localization.endless
            : '${invoice.remainingCycles}');
      case RecurringInvoiceFields.nextSendDate:
      case RecurringInvoiceFields.frequency:
      case RecurringInvoiceFields.dueDateDays:
      case RecurringInvoiceFields.autoBill:
    }

    return super.getField(field: field, context: context);
  }
}
