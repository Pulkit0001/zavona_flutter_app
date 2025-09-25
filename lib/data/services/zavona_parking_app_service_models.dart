import 'package:zavona_flutter_app/core/core.dart';

/// RequestloginregisterotpRequestParams for API request
class RequestloginregisterotpRequestParams extends BaseRequestParams {
  final String identifier;
  final String identifiertype;
  final String purpose;

  RequestloginregisterotpRequestParams({
    required this.identifier,
    required this.identifiertype,
    required this.purpose,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['identifier'] = identifier;
    data['identifierType'] = identifiertype;
    data['purpose'] = purpose;
    return data;
  }
}

/// VerifyotpRequestParams for API request
class VerifyotpRequestParams extends BaseRequestParams {
  final String identifier;
  final String otpcode;
  final String purpose;

  VerifyotpRequestParams({
    required this.identifier,
    required this.otpcode,
    required this.purpose,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['identifier'] = identifier;
    data['otpCode'] = otpcode;
    data['purpose'] = purpose;
    return data;
  }
}

/// LogoutRequestParams for API request
class LogoutRequestParams extends BaseRequestParams {
  final String sessionid;

  LogoutRequestParams({required this.sessionid});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['sessionId'] = sessionid;
    return data;
  }
}

/// SocialloginRequestParams for API request
class SocialloginRequestParams extends BaseRequestParams {
  final String provider;
  final String socialtoken;
  final String socialdataId;
  final String socialdataEmail;
  final String socialdataName;
  final String socialdataPicture;

  SocialloginRequestParams({
    required this.provider,
    required this.socialtoken,
    required this.socialdataId,
    required this.socialdataEmail,
    required this.socialdataName,
    required this.socialdataPicture,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['provider'] = provider;
    data['socialToken'] = socialtoken;
    data['socialData.id'] = socialdataId;
    data['socialData.email'] = socialdataEmail;
    data['socialData.name'] = socialdataName;
    data['socialData.picture'] = socialdataPicture;
    return data;
  }
}

/// UpdatefirebasetokenRequestParams for API request
class UpdatefirebasetokenRequestParams extends BaseRequestParams {
  final String firebasetoken;

  UpdatefirebasetokenRequestParams({required this.firebasetoken});

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['firebaseToken'] = firebasetoken;
    return data;
  }
}

/// GenerateuploadurlRequestParams for API request
class GenerateuploadurlRequestParams extends BaseRequestParams {
  final String filetype;
  final String filename;
  final String contenttype;

  GenerateuploadurlRequestParams({
    required this.filetype,
    required this.filename,
    required this.contenttype,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['fileType'] = filetype;
    data['fileName'] = filename;
    data['contentType'] = contenttype;
    return data;
  }
}

/// UserslistingQueryParams for API request
class UserslistingQueryParams extends BaseQueryParams {
  final String page;
  final String limit;
  final String? sortby;
  final String? sortorder;
  final String? userrole;
  final String? isactive;
  final String? isblocked;
  final String? emailverified;
  final String? mobileverified;
  final String? search;
  final String? datefrom;
  final String? dateto;

  UserslistingQueryParams({
    required this.page,
    required this.limit,
    this.sortby,
    this.sortorder,
    this.userrole,
    this.isactive,
    this.isblocked,
    this.emailverified,
    this.mobileverified,
    this.search,
    this.datefrom,
    this.dateto,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['limit'] = limit;
    if (sortby != null) data['sortBy'] = sortby;
    if (sortorder != null) data['sortOrder'] = sortorder;
    if (userrole != null) data['userRole'] = userrole;
    if (isactive != null) data['isActive'] = isactive;
    if (isblocked != null) data['isBlocked'] = isblocked;
    if (emailverified != null) data['emailVerified'] = emailverified;
    if (mobileverified != null) data['mobileVerified'] = mobileverified;
    if (search != null) data['search'] = search;
    if (datefrom != null) data['dateFrom'] = datefrom;
    if (dateto != null) data['dateTo'] = dateto;
    return data;
  }
}

/// UpdateprofileRequestParams for API request
class UpdateprofileRequestParams extends BaseRequestParams {
  final String name;
  final String email;
  final String mobile;
  final String profileimage;
  final String userrole;
  final bool emailverified;
  final bool mobileverified;
  final bool isactive;
  final bool isblocked;
  final String? kycStatus;
  final List<dynamic>? kycDocs;
  final String? kycRemarks;

  UpdateprofileRequestParams({
    required this.name,
    required this.email,
    required this.mobile,
    required this.profileimage,
    required this.userrole,
    required this.emailverified,
    required this.mobileverified,
    required this.isactive,
    required this.isblocked,
    this.kycStatus,
    this.kycDocs,
    this.kycRemarks,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['email'] = email;
    data['mobile'] = mobile;
    data['profileImage'] = profileimage;
    data['userRole'] = userrole;
    data['emailVerified'] = emailverified;
    data['mobileVerified'] = mobileverified;
    data['isActive'] = isactive;
    data['isBlocked'] = isblocked;
    if (kycStatus != null) data['kycStatus'] = kycStatus;
    if (kycDocs != null) data['kycDocs'] = kycDocs;
    if (kycRemarks != null) data['kycRemarks'] = kycRemarks;
    return data;
  }
}

/// CreateresidentialparkingspaceRequestParams for API request
class CreateresidentialparkingspaceRequestParams extends BaseRequestParams {
  final String name;
  final String areasocietyname;
  final String address;
  final String type;
  final double coordinatesLatitude;
  final double coordinatesLongitude;
  final List<String> images;
  final String thumbnailurl;
  final String owner;
  final String parkingnumber;
  final List<String> parkingsize;
  final bool availabletosell;
  final bool availabletorent;
  final num? sellingprice;
  final num? rentpriceperday;
  final num? rentpriceperhour;

  CreateresidentialparkingspaceRequestParams({
    required this.name,
    required this.areasocietyname,
    required this.type,
    required this.address,
    required this.coordinatesLatitude,
    required this.coordinatesLongitude,
    required this.images,
    required this.thumbnailurl,
    required this.owner,
    required this.parkingnumber,
    required this.parkingsize,
    required this.availabletosell,
    required this.availabletorent,
    required this.sellingprice,
    required this.rentpriceperday,
    required this.rentpriceperhour,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['type'] = type;
    data['areaSocietyName'] = areasocietyname;
    data['address'] = address;
    data['coordinates'] = {
      'latitude': coordinatesLatitude,
      'longitude': coordinatesLongitude,
    };
    data['images'] = images;
    data['thumbnailUrl'] = thumbnailurl;
    data['owner'] = owner;
    data['parkingNumber'] = parkingnumber;
    data['parkingSize'] = parkingsize;
    data['availableToSell'] = availabletosell;
    data['availableToRent'] = availabletorent;
    data['sellingPrice'] = sellingprice;
    data['rentPricePerDay'] = rentpriceperday;
    data['rentPricePerHour'] = rentpriceperhour;
    return data;
  }
}

/// ListparkingsQueryParams for API request
class ListparkingsQueryParams extends BaseQueryParams {
  final String page;
  final String limit;
  final String? owner;
  final String? areasocietyname;
  final String? isverified;
  final double? latitude;
  final double? longitude;
  final String? maxdistance;
  final String? minsellingprice;
  final String? maxsellingprice;
  final String? minrentpriceperday;
  final String? maxrentpriceperday;
  final String? minrentpriceperhour;
  final String? maxrentpriceperhour;
  final String? availabletosell;
  final String? availabletorent;

  ListparkingsQueryParams({
    required this.page,
    required this.limit,
    this.owner,
    this.areasocietyname,
    this.isverified,
    this.latitude,
    this.longitude,
    this.maxdistance,
    this.minsellingprice,
    this.maxsellingprice,
    this.minrentpriceperday,
    this.maxrentpriceperday,
    this.minrentpriceperhour,
    this.maxrentpriceperhour,
    this.availabletosell,
    this.availabletorent,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['limit'] = limit;
    if (owner != null) data['owner'] = owner;
    if (areasocietyname != null) data['areaSocietyName'] = areasocietyname;
    if (isverified != null) data['isVerified'] = isverified;
    if (latitude != null) data['latitude'] = latitude;
    if (longitude != null) data['longitude'] = longitude;
    if (maxdistance != null) data['maxDistance'] = maxdistance;
    if (minsellingprice != null) data['minSellingPrice'] = minsellingprice;
    if (maxsellingprice != null) data['maxSellingPrice'] = maxsellingprice;
    if (minrentpriceperday != null)
      data['minRentPricePerDay'] = minrentpriceperday;
    if (maxrentpriceperday != null)
      data['maxRentPricePerDay'] = maxrentpriceperday;
    if (minrentpriceperhour != null)
      data['minRentPricePerHour'] = minrentpriceperhour;
    if (maxrentpriceperhour != null)
      data['maxRentPricePerHour'] = maxrentpriceperhour;
    if (availabletosell != null) data['availableToSell'] = availabletosell;
    if (availabletorent != null) data['availableToRent'] = availabletorent;
    return data;
  }
}

/// UpdateresidentialparkingspaceRequestParams for API request
class UpdateresidentialparkingspaceRequestParams extends BaseRequestParams {
  final String name;
  final String areasocietyname;
  final String address;
  final double coordinatesLatitude;
  final double coordinatesLongitude;
  final List<String> images;
  final String thumbnailurl;
  final bool isverified;
  final String parkingnumber;
  final List<String> parkingsize;
  final bool availabletosell;
  final bool availabletorent;
  final num? rentpriceperday;
  final num? rentpriceperhour;
  final num? sellingprice;

  UpdateresidentialparkingspaceRequestParams({
    required this.name,
    required this.areasocietyname,
    required this.address,
    required this.coordinatesLatitude,
    required this.coordinatesLongitude,
    required this.images,
    required this.thumbnailurl,
    required this.isverified,
    required this.parkingnumber,
    required this.parkingsize,
    required this.availabletosell,
    required this.availabletorent,
    required this.rentpriceperday,
    required this.rentpriceperhour,
    required this.sellingprice,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['areaSocietyName'] = areasocietyname;
    data['address'] = address;
    data['coordinates.latitude'] = coordinatesLatitude;
    data['coordinates.longitude'] = coordinatesLongitude;
    data['images'] = images;
    data['thumbnailUrl'] = thumbnailurl;
    data['isVerified'] = isverified;
    data['parkingNumber'] = parkingnumber;
    data['parkingSize'] = parkingsize;
    data['availableToSell'] = availabletosell;
    data['availableToRent'] = availabletorent;
    data['rentPricePerDay'] = rentpriceperday;
    data['rentPricePerHour'] = rentpriceperhour;
    data['sellingPrice'] = sellingprice;
    return data;
  }
}

/// CreatepropertyinterestRequestParams for API request
class CreatepropertyinterestRequestParams extends BaseRequestParams {
  final String parkingspace;
  final String parkingspot;
  final String buyer;
  final String owner;
  final String interesttype;
  final int originalprice;
  final int offeredprice;
  final int leasedurationmonths;
  final String buyermessage;
  final String expiresat;
  final bool notifyforsimilar;
  final bool isactive;

  CreatepropertyinterestRequestParams({
    required this.parkingspace,
    required this.parkingspot,
    required this.buyer,
    required this.owner,
    required this.interesttype,
    required this.originalprice,
    required this.offeredprice,
    required this.leasedurationmonths,
    required this.buyermessage,
    required this.expiresat,
    required this.notifyforsimilar,
    required this.isactive,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['parkingSpace'] = parkingspace;
    data['parkingSpot'] = parkingspot;
    data['buyer'] = buyer;
    data['owner'] = owner;
    data['interestType'] = interesttype;
    data['originalPrice'] = originalprice;
    data['offeredPrice'] = offeredprice;
    data['leaseDurationMonths'] = leasedurationmonths;
    data['buyerMessage'] = buyermessage;
    data['expiresAt'] = expiresat;
    data['notifyForSimilar'] = notifyforsimilar;
    data['isActive'] = isactive;
    return data;
  }
}

/// GetallpropertyinterestsQueryParams for API request
class GetallpropertyinterestsQueryParams extends BaseQueryParams {
  final String page;
  final String limit;
  final String status;
  final String? interesttype;
  final String? buyer;
  final String? owner;
  final String? parkingspace;
  final String? parkingspot;
  final String sortby;
  final String order;

  GetallpropertyinterestsQueryParams({
    required this.page,
    required this.limit,
    required this.status,
    this.interesttype,
    this.buyer,
    this.owner,
    this.parkingspace,
    this.parkingspot,
    required this.sortby,
    required this.order,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['limit'] = limit;
    data['status'] = status;
    if (interesttype != null) data['interestType'] = interesttype;
    if (buyer != null) data['buyer'] = buyer;
    if (owner != null) data['owner'] = owner;
    if (parkingspace != null) data['parkingSpace'] = parkingspace;
    if (parkingspot != null) data['parkingSpot'] = parkingspot;
    data['sortBy'] = sortby;
    data['order'] = order;
    return data;
  }
}

/// CreatebookingRequestParams for API request
class CreatebookingRequestParams extends BaseRequestParams {
  final String parkingspace;
  final String parkingspot;
  final String renter;
  final String checkindatetime;
  final String checkoutdatetime;
  final String pricingRatetype;
  final num pricingRate;
  final num pricingPlatformfee;

  CreatebookingRequestParams({
    required this.parkingspace,
    required this.parkingspot,
    required this.renter,
    required this.checkindatetime,
    required this.checkoutdatetime,
    required this.pricingRatetype,
    required this.pricingRate,
    required this.pricingPlatformfee,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['parkingSpace'] = parkingspace;
    data['parkingSpot'] = parkingspot;
    data['renter'] = renter;
    data['checkInDateTime'] = checkindatetime;
    data['checkOutDateTime'] = checkoutdatetime;
    data['pricing'] = {
      'rateType': pricingRatetype,
      'rate': pricingRate,
      'platformFee': pricingPlatformfee,
    };
    return data;
  }
}

/// GetrentalbookingsQueryParams for API request
class GetrentalbookingsQueryParams extends BaseQueryParams {
  final String page;
  final String limit;
  final List<String>? status;
  final String? renter;
  final String? owner;
  final String? search;
  final String? sortby;

  GetrentalbookingsQueryParams({
    required this.page,
    required this.limit,
    this.status,
    this.renter,
    this.owner,
    this.search,
    this.sortby,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['limit'] = limit;
    if (status != null) data['status[]'] = status;
    if (renter != null) data['renter'] = renter;
    if (owner != null) data['owner'] = owner;
    if (search != null) data['search'] = search;
    if (sortby != null) data['sortBy'] = sortby;
    return data;
  }
}

/// UpdatebookingRequestParams for API request
class UpdatebookingRequestParams extends BaseRequestParams {
  final String checkoutdatetime;
  final int pricingPlatformfee;

  UpdatebookingRequestParams({
    required this.checkoutdatetime,
    required this.pricingPlatformfee,
  });

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['checkOutDateTime'] = checkoutdatetime;
    data['pricing.platformFee'] = pricingPlatformfee;
    return data;
  }
}
