#include "ExampleBootstrap.h"

#include <QQmlEngine>
#include <QtQml>

#include "ExampleModel.h"
#include "ExampleViewModel.h"
#include "backend/state/viewmodelregistry.h"

void setupExampleViewModel(QQmlEngine *engine)
{
    if (!engine)
        return;

    auto *registry = engine->singletonInstance<ViewModelRegistry *>(QStringLiteral("LVRS"),
                                                                     QStringLiteral("ViewModels"));
    if (!registry)
        return;

    auto *model = new ExampleModel(registry);
    auto *viewModel = new ExampleViewModel(model, registry);

    registry->set(QStringLiteral("Example"), viewModel);
}
