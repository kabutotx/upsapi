<cfscript>
// Gets UPSAPI token and writes token and expiration (minus 10 secs) to cookie. Will skip if already have non expired token.
if (not structKeyExists(cookie, "tokenExp")) {
	cfcookie(name="tokenExp", value="");
}
// Check token expiration
if (now() > cookie.tokenExp) {
id = ""; // OAuth id
secret = ""; //OAuth secret
upsapi = new upsapi(1);
result = upsapi.getAccessToken(id, secret);
if (result.status_code = 200){
	writeOutput("New Token");
	cfcookie(name="token", value=result.access_token);
	cfcookie(name="tokenExp", value=dateAdd("S", result.expires_in-10, now()));
}
writeDump(label="TOKEN", var=result);
}

token = cookie.token; // OAuth token from cookie above
upsapi = new upsapi(1);

/* RATE */
// Rate parameters in structure. Will default non required.
upsParameters = structNew();
upsParameters.version = "v1";
upsParameters.requestoption = "Shop"; // Rate or Shop
shipper_address = structNew();
shipper_address["AddressLine"] = arrayNew(1);
arrayAppend(shipper_address.AddressLine, "123 Company St.");
shipto_address = structNew();
shipto_address["AddressLine"] = arrayNew(1);
arrayAppend(shipto_address.AddressLine, "123 Customer St.");
upsRequest = structNew();
// Rate request structure with case sensitive keys
upsRequest["RateRequest"]["Request"]["RequestOption"]=upsParameters.requestoption;
//upsRequest["RateRequest"]["Shipment"]["Shipper"]["ShipperNumber"] = "1X1111"; // Optional: Your UPS Shipper Number to see negotiated rates. Must be attached to your account.
upsRequest["RateRequest"]["Shipment"]["Shipper"]["Address"] = shipper_address;
upsRequest["RateRequest"]["Shipment"]["Shipper"]["Address"]["StateProvinceCode"] = "MD";
upsRequest["RateRequest"]["Shipment"]["Shipper"]["Address"]["CountryCode"] = "US";
upsRequest["RateRequest"]["Shipment"]["Shipper"]["Address"]["PostalCode"] = "21093";
upsRequest["RateRequest"]["Shipment"]["ShipTo"]["Address"] = shipto_address;
upsRequest["RateRequest"]["Shipment"]["ShipTo"]["Address"]["StateProvinceCode"] = "GA";
upsRequest["RateRequest"]["Shipment"]["ShipTo"]["Address"]["CountryCode"] = "US";
upsRequest["RateRequest"]["Shipment"]["ShipTo"]["Address"]["PostalCode"] = "30005";
// upsRequest["RateRequest"]["Shipment"]["Service"]["Code"] = "03"; // Required if requestOption is "Rate"
upsRequest["RateRequest"]["Shipment"]["Package"]["PackagingType"]["Code"] = "02";
upsRequest["RateRequest"]["Shipment"]["Package"]["PackageWeight"]["UnitOfMeasurement"]["Code"] = "LBS";
upsRequest["RateRequest"]["Shipment"]["Package"]["PackageWeight"]["UnitOfMeasurement"]["Description"] = "Pounds";
upsRequest["RateRequest"]["Shipment"]["Package"]["PackageWeight"]["Weight"] = "02";
//upsRequest["RateRequest"]["Shipment"]["ShipmentRatingOptions"]["NegotiatedRatesIndicator"] = "Y"; // Optional: Use to see negotiated rates
result = upsapi.rating(token, upsParameters, upsRequest);
writeDump(label="RATE", var=result);

/* TRACKING */
upsParameters = structNew();
upsParameters.inquiryNumber = "1Z023E2X0214323462";
upsParameters.transId = "test";
//upsParameters.locale = "en_US";
//upsParameters.returnSignature = "true";
result = upsapi.tracking(token, upsParameters);
writeDump(label="TRACKING", var=result);

/* TIME IN TRANSIT */
upsParameters = structNew();
upsParameters.version = "v1";
upsRequest = structNew();
upsRequest["originCountryCode"]="DE";
upsRequest["originPostalCode"]="10703";
upsRequest["destinationCountryCode"]="US";
upsRequest["destinationStateProvince"]="NH";
upsRequest["destinationCityName"]="MANCHESTER";
upsRequest["destinationPostalCode"]="03104";
upsRequest["weight"]="10.5";
upsRequest["weightUnitOfMeasure"]="LBS";
upsRequest["shipmentContentsValue"]="10.5";
upsRequest["shipmentContentsCurrencyCode"]="USD";
upsRequest["billType"]="03";
upsRequest["avvFlag"]=true;
upsRequest["numberOfPackages"]="1";
result = upsapi.timeInTransit(token, upsParameters, upsRequest);
writeDump(label="TIME IN TRANSIT", var=result);

/* Address Validation */
upsParameters = structNew();
upsParameters.version = "v1";
//upsParameters.requestoption = "3";
address = arrayNew(1);
arrayAppend(address, "26601 ALISO CREEK ROAD");
arrayAppend(address, "STE D");
arrayAppend(address, "ALISO VIEJO TOWN CENTER");
upsRequest = structNew();
upsRequest["XAVRequest"]["AddressKeyFormat"]["ConsigneeName"]="ConsigneeName";
upsRequest["XAVRequest"]["AddressKeyFormat"]["BuildingName"]="Innoplex";
upsRequest["XAVRequest"]["AddressKeyFormat"]["AddressLine"]=address;
upsRequest["XAVRequest"]["AddressKeyFormat"]["Region"]="ROSWELL,GA,30076-1521";
upsRequest["XAVRequest"]["AddressKeyFormat"]["PoliticalDivision2"]="ALISO VIEJO";
upsRequest["XAVRequest"]["AddressKeyFormat"]["PoliticalDivision1"]="CA";
upsRequest["XAVRequest"]["AddressKeyFormat"]["PostcodePrimaryLow"]="92656";
upsRequest["XAVRequest"]["AddressKeyFormat"]["PostcodeExtendedLow"]="1521";
upsRequest["XAVRequest"]["AddressKeyFormat"]["Urbanization"]="porto arundal";
upsRequest["XAVRequest"]["AddressKeyFormat"]["CountryCode"]="US";
result = upsapi.addressValidation(token, upsParameters, upsRequest);
writeDump(label="ADDRESS VALIDATION", var=result);
</cfscript>