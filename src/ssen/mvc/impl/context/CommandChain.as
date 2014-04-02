package ssen.mvc.impl.context {
import flash.events.Event;

import ssen.mvc.ICommand;
import ssen.mvc.ICommandChain;
import ssen.mvc.IInjector;

/** @private implements class */
internal class CommandChain implements ICommandChain {
	//==========================================================================================
	// properties
	//==========================================================================================
	//----------------------------------------------------------------
	// dependent
	//----------------------------------------------------------------
	private var _event:Event;
	private var _commandClasses:Vector.<Class>;
	private var _injector:IInjector;

	//----------------------------------------------------------------
	// variables
	//----------------------------------------------------------------
	private var _current:int=-1;
	private var _data:Object;

	//==========================================================================================
	// constructor
	//==========================================================================================
	public function CommandChain(event:Event, injector:IInjector, commandClasses:Vector.<Class>) {
		_event=event;
		_injector=injector;
		_commandClasses=commandClasses;
	}

	//==========================================================================================
	// implements IEventChain
	//==========================================================================================
	public function get sharedData():Object {
		return _data||={};
	}

	public function get event():Event {
		return _event;
	}

	public function get current():int {
		return _current;
	}

	public function get numCommands():int {
		return _commandClasses.length;
	}

	public function next():void {
		if (++_current < _commandClasses.length) {
			var CommandClass:Class=_commandClasses[_current];
			var command:ICommand=new CommandClass;

			_injector.injectInto(command);

			command.execute(this);
		}
	}

	public function exit():void {
		_current=_commandClasses.length;
	}
}
}
