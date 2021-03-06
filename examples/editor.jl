using Hyperscript
using JSServe, Observables
using JSServe.DOM

using JSServe: Application, evaljs, linkjs
using JSServe: @js_str, onjs, Button, TextField, Slider, JSString, Dependency, with_session

struct Editor
    source::Observable{String}
    theme::Observable{String}
    language::Observable{String}
end

# Javascript & CSS dependencies can be declared locally and
# freely interpolated in the DOM / js string, and will make sure it loads
const ace = JSServe.Dependency(
    :ace,
    ["https://cdn.jsdelivr.net/gh/ajaxorg/ace-builds/src-min/ace.js"]
)

function dom_handler(session, request)
    s = Style(css("div",
        position = "absolute",
        top = 0,
        right = 0,
        bottom = 0,
        left = 0,
    ))
    dom = DOM.div("""
    function test{
        return 1;
    }""")
    JSServe.onload(session, dom, js"""
        function (element){
            var editor = $ace.edit(element);
            editor.setTheme("ace/theme/chrome");
            editor.session.setMode("ace/mode/javascript");
            editor.setOptions({
                autoScrollEditorIntoView: true,
                copyWithEmptySelection: true,
            });

            editor.resize();
            // use setOptions method to set several options at once
            editor.setOptions({
                autoScrollEditorIntoView: true,
                copyWithEmptySelection: true,
            });
            // use setOptions method
            editor.setOption("mergeUndoDeltas", "always");

        }
    """)
    return DOM.div(DOM.style(styles(s)), s(dom))
end

app = Application(dom_handler, "127.0.0.1", 8081)
