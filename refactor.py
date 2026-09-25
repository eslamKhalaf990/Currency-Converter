import os
import re

ROOT = '/Users/ekhalaf/StudioProjects/currency_converter/lib'

def abs_path(subpath):
    return os.path.join(ROOT, subpath)

moves = {
    # Generic Widgets
    'features/currency_converter/presentation/widgets/app_button.dart': 'core/widgets/app_button.dart',
    'features/currency_converter/presentation/widgets/app_container.dart': 'core/widgets/app_container.dart',
    'features/currency_converter/presentation/widgets/app_text.dart': 'core/widgets/app_text.dart',
    'features/currency_converter/presentation/widgets/app_text_field.dart': 'core/widgets/app_text_field.dart',

    # History Feature
    'features/currency_converter/domain/entities/conversion_record.dart': 'features/history/domain/entities/conversion_record.dart',
    'features/currency_converter/domain/repositories/currency_repository.dart': 'features/history/domain/repositories/history_repository.dart', # wait, currency_repository has all of it
}
