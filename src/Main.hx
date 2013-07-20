package ;
import neko.Lib;
using totsubefu.Interpreter;
@:build(totsubefu.Interpreter.parse(":b"))
class Main {
	function new() {
		hello();
	}
	@:b function hello() {'
v @_       v
>0"!dlroW"v 
v  :#     < 
>" ,olleH" v
   ^       <
	';}
	static function main() {
		Interpreter.setPrint(Lib.print);
		new Main();
	}
}