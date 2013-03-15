-module(boss_form_widget).
-compile(export_all).


%% Widget proxy
widget(DefaultType, Name, Options, Value) ->
    Widget = proplists:get_value(widget, Options, DefaultType),
    case Widget of
        {Mod, Func} ->
            apply(Mod, Func, [Name, Value, Options]);
        Widget when is_atom(Widget) ->
            apply(boss_form_widget, Widget, [Name, Value, Options])
    end.

%% Elements
input_element(Type, Name, undefined, Options) ->
    input_element(Type, Name, proplists:get_value(default, Options, ""), Options);
input_element(Type, Name, Value, _Options) ->
    io_lib:format("<input type='~s' name='~s' value='~s' />", [Type, Name, Value]).

select_element(Name, undefined, Options) ->
    select_element(Name, [], Options);
select_element(Name, Values, Options) ->
    io_lib:format("<select name='~s'>~s</select>", [Name, select_options(Values, Options)]).

select_options(Values, Options) ->
    [select_option(Values, Id, Title) || {Id, Title} <- proplists:get_value(choices, Options, [])].

select_option(Values, Id, Title) when is_integer(Id) ->
    select_option(Values, integer_to_list(Id), Title);
select_option(Values, Id, Title) ->
    Selected = case lists:member(Id, Values) of
        true -> " selected";
        false -> ""
    end,
    io_lib:format("<option value='~s'~s>~s</option>", [Id, Selected, Title]).

textarea_element(Name, undefined, Options) ->
    textarea_element(Name, proplists:get_value(default, Options, ""), Options);
textarea_element(Name, Value, _Options) ->
    io_lib:format("<textarea name='~s'>~s</textarea>", [Name, Value]).

%% HTML fields
checkbox_input(Name, undefined, Options) ->
    checkbox_input(Name, "1", Options);
checkbox_input(Name, Value, Options) ->
    input_element(checkbox, Name, Value, Options).

text_input(Name, Value, Options) ->
    input_element(text, Name, Value, Options).

password_input(Name, Value, Options) ->
    input_element(password, Name, Value, Options).

select(Name, Value, Options) ->
    select_element(Name, Value, Options).

textarea(Name, Value, Options) ->
    textarea_element(Name, Value, Options).