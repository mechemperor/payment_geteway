import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {

  List name = ["jay","uttam","savan","raj","shyam"];
  List amount = [10000,50000,1000,5000,2000];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("first page"),
      ),
      body: ListView.builder(
        itemCount: name.length,
        itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Razorpay razorpay = Razorpay();
            var options = {
              // 'key': 'rzp_live_ILgsfZCZoFIKMb',
              'key': 'rzp_test_yoqHdpBjqOcsXL',
              'amount': amount[index],
              'name': '${name[index]}',
              'description': 'Fine T-Shirt',
              'retry': {'enabled': true, 'max_count': 1},
              'send_sms_hash': true,
              'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'},
              'external': {
                'wallets': ['paytm']
              }
            };
            razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
            razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
            razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
            razorpay.open(options);
          },
          child: ListTile(
            title: Text("${name[index]}"),
            subtitle: Text("${amount[index]}"),
          ),
        );
      },),
    );
  }
  void handlePaymentErrorResponse(PaymentFailureResponse response){
    /*
    * PaymentFailureResponse contains three values:
    * 1. Error Code
    * 2. Error Description
    * 3. Metadata
    * */
    showAlertDialog(context, "Payment Failed", "Code: ${response.code}\nDescription: ${response.message}\nMetadata:${response.error.toString()}");
  }

  void handlePaymentSuccessResponse(PaymentSuccessResponse response){
    /*
    * Payment Success Response contains three values:
    * 1. Order ID
    * 2. Payment ID
    * 3. Signature
    * */
    showAlertDialog(context, "Payment Successful", "Payment ID: ${response.paymentId}");
  }

  void handleExternalWalletSelected(ExternalWalletResponse response){
    showAlertDialog(context, "External Wallet Selected", "${response.walletName}");
  }
  void showAlertDialog(BuildContext context, String title, String message){
    // set up the buttons
    Widget continueButton = ElevatedButton(
      child: const Text("Continue"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
