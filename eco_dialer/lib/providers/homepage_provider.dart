import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class HomePageProvider extends ChangeNotifier {
  String serviceProvider = 'Flow';
  String selectedCategory = 'Utilities';

  List<String> serviceProviders = ['Flow', 'Digicel'];
  List<String> categories = [
    'Utilities',
    'Combo Plans',
    'Data Plans',
    'Roaming'
  ];

  Map<String, Map<String, List<Map<String, String>>>> numbers = {
    'Digicel': {
      'Utilities': [
        {'action': 'My Balance', 'number': '*120#'},
        {'action': 'My Number', 'number': '*129#'},
        {'action': 'Data Balance', 'number': '*136#'},
        {'action': 'Get Active Plans', 'number': '*123#'}
      ],
      'Combo Plans': [
        {'action': '1-Day 1GB/20mins ', 'number': '*129*6*3*1#'},
        {'action': '3-Day 4GB/150mins ', 'number': '*129*6*3*2#'},
        {'action': '7-Day 8GB/500mins ', 'number': '*129*6*3*3#'},
        {'action': '30-Day 16GB/800mins ', 'number': '*129*6*3*4#'},
        {'action': '30-Day 16GB/800mins ', 'number': '*129*6*3*4#'},
      ],
      'Data Plans': [
        {'action': '1-Day 500MB', 'number': '*129*6*1*1#', 'cost': '\$3.00'},
        {'action': '3-Day 2GB', 'number': '*129*6*1*2#', 'cost': '\$9.00'},
        {'action': '7-Day 5GB', 'number': '*129*6*1*3#', 'cost': '\$22.00'},
        {'action': '14-Day 10GB', 'number': '*129*6*1*4#', 'cost': '\$40.00'},
        {'action': '30-Day 12GB', 'number': '*129*6*1*5#', 'cost': '\$50.00'},
      ],
      'Roaming': [
        {'action': 'Travel Pass 500MB Data', 'number': '*129*6*4*1#'},
        {'action': 'Int Roaming', 'number': '*129*6*4*2#'},
      ]
    },
    'Flow': {
      'Utilities': [
        {'action': 'My Balance', 'number': '*120#'},
        {'action': 'Please call me', 'number': '*126*XXXX-XXX-XXXX#'},
        {'action': 'Data Balance', 'number': '*129*4#'},
        {'action': 'Cancel Auto-Renewal', 'number': '*363*1#'},
        {'action': 'My Number', 'number': '*129*7*1#'},
        {'action': 'Get Active Plans', 'number': '*129*5#'},
        {'action': 'General Menu', 'number': '*129#'},
      ],
      'Combo Plans': [
        {'action': '1-Day 1GB/20mins ', 'number': '*129*6*3*1#', 'cost': '\$5'},
        {
          'action': '3-Day 4GB/150mins ',
          'number': '*129*6*3*2#',
          'cost': '\$12'
        },
        {
          'action': '7-Day 8GB/500mins ',
          'number': '*129*6*3*3#',
          'cost': '\$30'
        },
        {
          'action': '30-Day 16GB/800mins ',
          'number': '*129*6*3*4#',
          'cost': '\$75'
        },
      ],
      'Data Plans': [
        {'action': '1-Day 500MB', 'number': '*129*6*1*1#', 'cost': '\$3.00'},
        {'action': '3-Day 2GB', 'number': '*129*6*1*2#', 'cost': '\$9.00'},
        {'action': '7-Day 5GB', 'number': '*129*6*1*3#', 'cost': '\$22.00'},
        {'action': '14-Day 10GB', 'number': '*129*6*1*4#', 'cost': '\$40.00'},
        {'action': '30-Day 12GB', 'number': '*129*6*1*5#', 'cost': '\$50.00'},
      ],
      'Roaming': [
        {'action': 'Travel Pass 500MB Data', 'number': '*129*6*4*1#'},
        {'action': 'Int Roaming', 'number': '*129*6*4*2#'},
      ]
    }
  };

  void setServiceProvider(String serviceProvider) {
    this.serviceProvider = serviceProvider;
    notifyListeners();
  }

  void setSelectedCategory(String selectedCategory) {
    this.selectedCategory = selectedCategory;
    notifyListeners();
  }
}
