import {DOM, Webpack, Injector as InjectorModule, DiscordModules} from "@Holy"
import config from "./manifest.json"
import DevtoolsButton from "./components/button"
import styles from "./index.scss"

{Dispatcher} = DiscordModules

Injector = InjectorModule.create config.name

export default class DevUtils
    onStart: -> 
        @patchTitleBar()
        DOM.injectCSS config.name, styles
        @forceUpdateBar()
        document.addEventListener "keydown", @onKeydown
        @exposeModules()

    exposeModules: ->
        Expose = (obj) ->
            for i of obj
                window[i] = obj[i]

        Expose window.HolyAPI
        Expose window.HolyAPI.DiscordModules

    patchTitleBar: ->
        TitleBar = Webpack.findModule (m) -> m.default?.displayName is undefined and m.default.toString().includes "PlatformTypes.WINDOWS"

        CustomTitleBar = (props) ->
            returnValue = props.original.apply this, arguments

            try if returnValue isnt null
                childs = returnValue.props.children

                if Array.isArray childs
                   childs.push <DevtoolsButton icon="Terminal" />, <DevtoolsButton icon="Debug" />

            return returnValue

        Injector.inject {
            module: TitleBar
            method: "default"
            after: (_, __, ret) -> 
                return unless typeof ret.type is "function"

                Object.assign ret.props, {original: ret.type}
                ret.type = CustomTitleBar
                return ret
        }

    onKeydown: (event) ->
        return unless event.key is "F8"

        debugger

    forceUpdateBar: ->
        Dispatcher.dirtyDispatch {type: "WINDOW_FOCUS"}

    onStop: -> 
        Injector.uninject()
        DOM.clearCSS config.name
        @forceUpdateBar()
        document.removeEventListener "keydown", @onKeydown