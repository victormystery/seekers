import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seeker_ng/service/all_services_service.dart';
import 'package:seeker_ng/service/dropdowns_services/country_dropdown_service.dart';
import 'package:seeker_ng/view/auth/signup/dropdowns/country_dropdown.dart';
import 'package:seeker_ng/view/auth/signup/dropdowns/state_dropdown.dart';
import 'package:seeker_ng/view/services/components/service_filter_dropdown_helper.dart';
import 'package:seeker_ng/view/utils/constant_colors.dart';
import 'package:seeker_ng/view/utils/constant_styles.dart';

class JobEditDropdowns extends StatefulWidget {
  const JobEditDropdowns({Key? key}) : super(key: key);

  @override
  State<JobEditDropdowns> createState() => _JobEditDropdownsState();
}

class _JobEditDropdownsState extends State<JobEditDropdowns> {
  @override
  void initState() {
    super.initState();
    //fetch country
    Provider.of<CountryDropdownService>(context, listen: false)
        .fetchCountries(context);

    Provider.of<AllServicesService>(context, listen: false)
        .fetchCategories(context);
  }

  @override
  Widget build(BuildContext context) {
    ConstantColors cc = ConstantColors();
    return Consumer<AllServicesService>(
      builder: (context, filterProvider, child) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //dropdown and search box
          const SizedBox(
            width: 17,
          ),

          // Category dropdown ===============>
          ServiceFilterDropdownHelper().categoryDropdown(cc, context),

          const SizedBox(
            height: 25,
          ),

          // States dropdown ===============>
          ServiceFilterDropdownHelper().subCategoryDropdown(cc, context),

          const SizedBox(
            height: 25,
          ),

          const CountryDropdown(),

          sizedBoxCustom(20),

          const StateDropdown()
        ],
      ),
    );
  }
}
