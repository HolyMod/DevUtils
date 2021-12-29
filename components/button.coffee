import {DiscordModules, toggleDevTools} from "@Holy"
import Terminal from "./icons/terminal"
import Debug from "./icons/debug"

Icons = {
    Terminal
    Debug
}

{Button, Flex} = DiscordModules

export default DevtoolsButton = (props) ->
    handleClick = () -> 
        switch props.icon
            when "Terminal" then toggleDevTools()
            when "Debug" then debugger

    Icon = Icons[props.icon]
    
    if Icon is undefined 
        return null

    <Button 
        size={Button.Sizes.NONE} 
        look={Button.Looks.BLANK} 
        className={"winButton-iRh8-Z dev-title-button #{Flex.Align.CENTER}"} 
        onClick={handleClick}
        innerClassName={Flex.Justify.CENTER}
    >
        <Icon width="16" height="16" />
    </Button>