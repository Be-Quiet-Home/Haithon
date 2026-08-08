#include <pybind11/pybind11.h>
#include <pybind11/stl.h>
#include <pybind11/iostream.h>
#include <pybind11/operators.h>

#include <interface/LayoutContext.h>
#include <List.h>

namespace py = pybind11;


class PyBLayoutContextListener : public BLayoutContextListener {
public:
    using BLayoutContextListener::BLayoutContextListener;

    void LayoutContextLeft(BLayoutContext* context) override {
        PYBIND11_OVERRIDE_PURE(void, BLayoutContextListener, LayoutContextLeft, context);
    }
};

PYBIND11_MODULE(LayoutContext,m)
{
py::class_<BLayoutContextListener,PyBLayoutContextListener>(m, "BLayoutContextListener")
.def(py::init(), "")
.def("LayoutContextLeft", &BLayoutContextListener::LayoutContextLeft, "", py::arg("context"))
;

py::class_<BLayoutContext>(m, "BLayoutContext", py::dynamic_attr())
.def(py::init(), "")
.def("AddListener", [](BLayoutContext& self,
        BLayoutContextListener* listener) {
    self.AddListener(listener);
    if (listener == nullptr)
        return;

    py::object owner
        = py::cast(&self, py::return_value_policy::reference);

    py::list listeners;
    if (py::hasattr(owner, "_haithon_layout_context_listener_refs")) {
        listeners = owner.attr(
            "_haithon_layout_context_listener_refs").cast<py::list>();
    } else {
        listeners = py::list();
        owner.attr("_haithon_layout_context_listener_refs") = listeners;
    }

    listeners.append(
        py::cast(listener, py::return_value_policy::reference));
}, "", py::arg("listener"))
.def("RemoveListener", [](BLayoutContext& self,
        BLayoutContextListener* listener) {
    self.RemoveListener(listener);
    if (listener == nullptr)
        return;

    py::object owner
        = py::cast(&self, py::return_value_policy::reference);

    if (!py::hasattr(owner, "_haithon_layout_context_listener_refs"))
        return;

    py::list listeners = owner.attr(
        "_haithon_layout_context_listener_refs").cast<py::list>();

    py::object target
        = py::cast(listener, py::return_value_policy::reference);

    for (py::ssize_t i = 0; i < py::len(listeners); i++) {
        py::object item = listeners[i].cast<py::object>();
        if (item.is(target)) {
            listeners.attr("pop")(i);
            break;
        }
    }
}, "", py::arg("listener"))
;


}
