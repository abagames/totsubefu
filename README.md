totsubefu
======================
The test program of a Haxe macro of building types with the Befunge interpreter.

* [Building Types with Macros](http://haxe.org/manual/macros/build)
* [Befunge](http://en.wikipedia.org/wiki/Befunge)

Write a code,

```haxe
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
```

build it and

```
% haxe -main Main.hx -neko Main.n
totsubefu/Interpreter.hx:20: 
＿人人 人人 人人＿
＞ 突然のBefunge ＜
￣Y^Y^Y^Y^Y^Y^Y￣

v @_       v
>0"!dlroW"v 
v  :#     < 
>" ,olleH" v
   ^       <
	
```

execute it.

```
% neko Main.n
Hello, World!
```

License
----------
Copyright &copy; 2013 ABA Games

Distributed under the [MIT License][MIT].

[MIT]: http://www.opensource.org/licenses/mit-license.php
