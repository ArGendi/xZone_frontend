import 'package:flutter/foundation.dart';
import 'package:xzone/models/Zone.dart';

class ZoneProvider extends ChangeNotifier {
  List<Zone> zones = [
    Zone(
        name: "Kersh Keepers",
        numberOfmembers: 12000,
        skill: "health",
        admins: ["ahmed", "mohamed"]),
    Zone(
        name: "sportives",
        numberOfmembers: 12000,
        skill: "sports",
        admins: ["waleed", "tarek", ""]),
    Zone(
        name: "DS community",
        numberOfmembers: 12000,
        skill: "programming",
        admins: ["nardine", "Nabil", "", " "]),
    Zone(
        name: "Kersh Keepers",
        numberOfmembers: 12000,
        skill: "health",
        admins: ["ahmed", "mohamed"]),
    Zone(
        name: "Kersh Keepers",
        numberOfmembers: 12000,
        skill: "health",
        admins: ["ahmed", "mohamed"]),
    Zone(
        name: "Kersh Keepers",
        numberOfmembers: 12000,
        skill: "health",
        admins: ["ahmed", "mohamed"]),
    Zone(
        name: "Kersh Keepers",
        numberOfmembers: 12000,
        skill: "health",
        admins: ["ahmed", "mohamed"]),
  ];
}
