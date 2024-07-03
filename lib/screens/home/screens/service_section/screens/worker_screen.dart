import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:souq_alqua/screens/home/screens/service_section/provider/service_provider.dart';
import 'package:souq_alqua/utils/color_class.dart';
import 'package:souq_alqua/utils/style_class.dart';

class AllWorkersScreen extends StatefulWidget {
  final String title;
  final String serviceKey;
  final String serviceIcon;
  const AllWorkersScreen(
      {super.key,
      required this.title,
      required this.serviceKey,
      required this.serviceIcon});

  @override
  State<AllWorkersScreen> createState() => _AllWorkersScreenState();
}

class Worker {
  final String name;
  final List<String> jobs;

  Worker({required this.name, required this.jobs});
}

class _AllWorkersScreenState extends State<AllWorkersScreen> {
  @override
  void initState() {
    super.initState();
    ServiceProvider provider =
        Provider.of<ServiceProvider>(context, listen: false);

    Future.microtask(() async {
      await provider.fetchWorkers(serviceType: widget.serviceKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // arabic layout for the app bar

          AppBar(
        title: Text(
          widget.title,
          style: TextStyleClass.text14GreyAr,
        ),
      ),
      body: Consumer<ServiceProvider>(
        builder: (context, snapshot, child) => snapshot.fetchWorkersLoading
            ? Center(
                child: LoadingAnimationWidget.horizontalRotatingDots(
                  color: ColorClass.kPrimaryColor,
                  size: 35,
                ),
              )
            :
            // check empty workers
            snapshot.serviceWorkers.isEmpty
                ? Center(
                    child: Text(
                      'No ${widget.serviceKey} available',
                      style: TextStyleClass.text16Black,
                    ),
                  )
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.serviceWorkers.length,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          itemBuilder: (context, index) => Container(
                            margin: const EdgeInsets.only(bottom: 10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  offset: const Offset(0, 4),
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                ),
                              ],
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: ColorClass.kPrimaryColor
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Image.asset(
                                      widget.serviceIcon,
                                      height: 30,
                                      width: 30,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.serviceWorkers[index].name,
                                        style: TextStyleClass.text16Black,
                                        maxLines: 3,
                                      ),
                                      const SizedBox(height: 4),
                                      // works he can do
                                      Visibility(
                                        visible: snapshot
                                            .serviceWorkers[index].service
                                            .toString()
                                            .isNotEmpty,
                                        child: LayoutBuilder(
                                          builder: (context, constraints) {
                                            // recive  the service list in a string with comma separated values and split it
                                            List workersList = snapshot
                                                .serviceWorkers[index].service
                                                .toString()
                                                .split(',');
                                            return Wrap(
                                              spacing: 8.0,
                                              runSpacing: 4.0,
                                              children: List.generate(
                                                  workersList.length, (index) {
                                                return Container(
                                                  padding:
                                                      const EdgeInsets.all(4),
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        137, 229, 241, 255),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            6),
                                                  ),
                                                  child: Text(
                                                    workersList[index],
                                                    style: TextStyleClass
                                                        .text12Black,
                                                  ),
                                                );
                                              }).toList(),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Visibility(
                                  visible: snapshot
                                      .serviceWorkers[index].location
                                      .toString()
                                      .isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () {
                                      snapshot
                                          .createActivity(
                                              serviceProvider: snapshot
                                                  .serviceWorkers[index].name,
                                              serviceProviderPh: snapshot
                                                  .serviceWorkers[index]
                                                  .phoneNumber,
                                              serviceType: snapshot
                                                  .serviceWorkers[index]
                                                  .serviceType,
                                              activity: "map")
                                          .then(
                                            (value) => snapshot.launchUrlMap(
                                                snapshot.serviceWorkers[index]
                                                    .location),
                                          );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: ColorClass.greenColor
                                            .withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.location_on,
                                          color: ColorClass.greenColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Visibility(
                                  visible: snapshot
                                      .serviceWorkers[index].phoneNumber
                                      .toString()
                                      .isNotEmpty,
                                  child: GestureDetector(
                                    onTap: () {
                                      snapshot
                                          .createActivity(
                                              serviceProvider: snapshot
                                                  .serviceWorkers[index].name,
                                              serviceProviderPh: snapshot
                                                  .serviceWorkers[index]
                                                  .phoneNumber,
                                              serviceType: snapshot
                                                  .serviceWorkers[index]
                                                  .serviceType,
                                              activity: "call")
                                          .then(
                                            (value) => snapshot.launchPhoneUrls(
                                                // remove all spaces from the phone number
                                                snapshot.serviceWorkers[index]
                                                    .phoneNumber
                                                    .replaceAll(" ", "")),
                                          );
                                    },
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                        color: ColorClass.kPrimaryColor
                                            .withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.call,
                                          color: ColorClass.kPrimaryColor,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
