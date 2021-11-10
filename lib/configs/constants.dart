import 'package:flutter/material.dart';
import 'package:sportiwe_admin/controllers/app_controller.dart';

const primaryColor = Color(0xFF2697FF);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);

const defaultPadding = 16.0;

final String ADMIN_COLLECTION = "admin";
final String COMPANY_USERS_COLLECTION = "company_users";
final String VENUES_COLLECTION = "venues";
final String COUPON_COLLECTION = "coupons";


final String ROLES_DOCUMENT = "roles";
final String COUNTERS_DOCUMENT = "counters";
final String PLACES_DOCUMENT = "places";
final String COMPANY_USER_COUNTER = "company_user_counter";

final String SPORTIWE_USER_PREFIX = "SPW";

final String USER_ADMIN = "user_admin";
final String USER_GROUND = "user_ground";
final String USER_MODERATOR = "user_moderator";

String VENUES_DEV_INDEX = "venues_dev";
String REPORT_DEV_INDEX = "reports_dev";

String getVenuesIndex() =>  VENUES_DEV_INDEX ;
String getReportIndex() =>  REPORT_DEV_INDEX ;