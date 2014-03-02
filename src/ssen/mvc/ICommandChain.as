package ssen.mvc {
import flash.events.Event;

public interface ICommandChain {
	function get event():Event;

	function get current():int;
	function get numCommands():int;

	function get data():Object;

	function next():void;
	function exit():void;
}
}
