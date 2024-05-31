/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const stripe = require("stripe")(functions.config().stripe.secret_key);

const calculateOrderAmount =(items)
{
prices[];
catalog =[
{   id: 0,price:100, },
{   id: 1,price:100, },
{   id: 2,price:100, },
{   id: 3,price:100, },
];
items.forEach(item => {
price = catalog.find(x => x.id === item.id).price;
prices.push(price);

} );
return prices.reduce((a,b) => a + b)*100 );
}
const generateResponse =function (intent){
Switch(intent.status){
   case 'requires_action':
   return {
   clientSecret: intent.client_secret,
   requiresAction: true,
  status : intent.status,
   } ;
   case 'requires_payment_method':
   return {
   error: {
   message: 'Your card was declined.'
   };
   case 'succeeded':
   console.log('💰 Payment succeeded!');
   return {
   clientSecret: intent.client_secret,

   status : intent.status,
   } ;
}
     return { error: 'Failed' };
}
exports.StripePayEndpointMethod = functions.https.onRequest(async(req,res) => {
const {paymentMethodId,items,currency,useStripeSdk,} = req.body;
const orderAmount =calculateOrderAmount(items);
try {
 if(paymentMethodId)
 {
 //create a new payment intent with the order amount and currency
 const params = {
 amount: orderAmount,
 currency: currency,
 payment_method: paymentMethodId,
 confirm: true,
 confirmation_method: "manual",
 useStripeSdk: useStripeSdk,

 };
 const intent = await stripe.paymentIntents.create(params);
 console.log('Intent :${intent}');
 return res.send(generateResponse(intent));
 }
 return res.sendStatus(400);

} catch(e){
    return res.send({error: e.message});
}
}
});
exports.StripePayEndpointIntentId = functions.https.onRequest(async(req,res) => {
     const {paymentIntentId} = req.body;
     try {
     if(paymentIntentId){
     const intent = await stripe.paymentIntents.confirm(paymentIntentId);
     return res.send(generateResponse(intent));
     }
     return res.sendStatus(400);

     }catch(e){
          return res.send({error: e.message});
     }
};


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
