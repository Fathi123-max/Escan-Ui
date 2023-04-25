import 'package:escan_ui/common/constants.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';

class HouseController {
  Future<House?> getHouseById(String id) async {
    // In a real-world scenario, you should replace this with a database or api call to get the house by id.
    // For this example, we just loop through the list of houses and find the house with the matching id.
    for (House house in Constants.houseList) {
      if (house.id == id) {
        return house;
      }
    }
    return null; // If the house is not found, return null.
  }
}
