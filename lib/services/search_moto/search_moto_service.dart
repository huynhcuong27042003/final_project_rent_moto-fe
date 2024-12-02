import 'package:final_project_rent_moto_fe/services/categoryMoto/fetch_category_service.dart';
import 'package:final_project_rent_moto_fe/services/companyMoto/fetch_company_service.dart';
import 'package:flutter/material.dart';

class SearchMotoService {
  Widget customIconTextButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    required BuildContext context,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
          side: BorderSide(width: 0.5),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.black,
          ),
          SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w700, fontSize: 12, color: Colors.black),
          ),
        ],
      ),
    );
  }

  void showBottomCategorySheetModal(
      BuildContext context, Function(String) onCategorySelected) async {
    final categoryService = FetchCategoryService();
    List<Map<String, dynamic>> categories =
        await categoryService.fetchCategories();

    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Chọn loại xe",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return ListTile(
                          title: Text(category['name']),
                          leading: Radio<String>(
                            value: category['name'],
                            groupValue: selectedCategory,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCategory = value;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCategory != null) {
                        onCategorySelected(selectedCategory!);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Xác nhận"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void showBottomCompanySheetModal(
      BuildContext context, Function(String) onCompanySelected) async {
    final companyService = FetchCompanyService();
    List<Map<String, dynamic>> companies =
        await companyService.fetchCompanies();

    String? selectedCompany;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.3,
              color: Colors.white,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Chọn hãng xe",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: companies.length,
                      itemBuilder: (context, index) {
                        final company = companies[index];
                        return ListTile(
                          title: Text(company['name']),
                          leading: Radio<String>(
                            value: company['name'],
                            groupValue: selectedCompany,
                            onChanged: (String? value) {
                              setState(() {
                                selectedCompany = value;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedCompany != null) {
                        onCompanySelected(selectedCompany!);
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Xác nhận"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
