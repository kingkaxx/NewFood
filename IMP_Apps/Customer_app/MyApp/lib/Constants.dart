const PAYMENT_URL =
    "http://127.0.0.1:5000/paymentgateway-6af76/us-central1/customFunctions/payment";

const ORDER_DATA = {
  "custID": "USER_0987654321",
  "custEmail": "qwertyui@gmail.com",
  "custPhone": "1234567890"
};

const STATUS_LOADING = "PAYMENT_LOADING";
const STATUS_SUCCESSFUL = "PAYMENT_SUCCESSFUL";
const STATUS_PENDING = "PAYMENT_PENDING";
const STATUS_FAILED = "PAYMENT_FAILED";
const STATUS_CHECKSUM_FAILED = "PAYMENT_CHECKSUM_FAILED";
