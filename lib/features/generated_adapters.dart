import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:quicksnap/features/app_update/models.dart';
import 'package:quicksnap/features/settings/models.dart';

@GenerateAdapters(
  [
    AdapterSpec<QuickSnapSettings>(),
    AdapterSpec<ThemeMode>(),
    AdapterSpec<UserColorEnum>(),
    AdapterSpec<UpdateConfig>()
  ],
) // DO this to make QuickSnapSettings Hive compatible(i.e serialiazable and deserializable), and generate the adapter using build_runner
part 'generated_adapters.g.dart';
