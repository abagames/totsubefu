package totsubefu;
import haxe.macro.Context;
import haxe.macro.Expr;
using Lambda;
using StringTools;
class Interpreter {
	macro static public function parse(metaName:String):Array<Field> {
		var bf = Context.getBuildFields();
		for (field in bf) {
			switch(field.kind) {
			case FFun(f):
				if (field.meta.exists(function(m) { return m.name == metaName; } )) {
					var fe = f.expr;
					switch (fe.expr) {
					case EBlock(blocks):
						switch (blocks[0].expr) {
						case EConst(c):
							switch (c) {
							case CString(s):
								trace('
ÅQêlêl êlêl êlêlÅQ
ÅÑ ìÀëRÇÃBefunge ÅÉ
ÅPY^Y^Y^Y^Y^Y^YÅP
${s}');
								var nbs = new Array<Expr>();
								var ne = Context.parse('new totsubefu.Interpreter(\'${s}\')' , blocks[0].pos);
								nbs.push(ne);
								fe.expr = EBlock(nbs);
							default:
							}
						default:
						}
					default:
					}
				}
			default:
			}
		}
		return bf;
	}
	static var print:Dynamic -> Void;
	static public function setPrint(pln:Dynamic -> Void):Void {
		print = pln;
	}
	var code:Array<Array<String>>;
	var size:V;
	var pc:V;
	var pcv = 0;
	var stack:Array<Int>;
	var isStrMode = false;
	public function new(codeStr:String) {
		code = new Array<Array<String>>();
		var maxWidth = 0;
		for (ls in codeStr.split("\n")) {
			ls = ls.replace("\r", "");
			if (ls.length <= 0) continue;
			var l = ls.split("");
			if (l.foreach(function(c) { return c.isSpace(0); } )) continue;
			code.push(l);
			if (l.length > maxWidth) maxWidth = l.length;
		}
		for (l in code) {
			var ll = l.length;
			for (i in ll...maxWidth) l.push(" ");
		}
		size = new V(maxWidth, code.length);
		pc = new V();
		stack = new Array<Int>();
		begin();
	}
	function begin() {
		for (i in 0...9999) {
			if (!exec()) return;
			move();
		}
	}
	function exec() {
		var c = code[pc.y][pc.x];
		//trace('${c}(${pc.x}, ${pc.y})');
		if (c != '"' && isStrMode) {
			push(c.charCodeAt(0));
			return true;
		}
		switch (c) {
		case '<':
			pcv = 2;
		case '>':
			pcv = 0;
		case '^':
			pcv = 3;
		case 'v':
			pcv = 1;
		case '_':
			pcv = pop() == 0 ? 0 : 2;
		case '|':
			pcv = pop() == 0 ? 1 : 3;
		case '?':
			pcv = Std.int(Math.random() * 4);
		case '#':
			move();
		case '@':
			return false;
		case '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
			push(Std.parseInt(c));
		case '"':
			isStrMode = !isStrMode;
		case '.':
			print(pop() + " ");
		case ',':
			print(String.fromCharCode(pop()));
		case '!':
			push(pop() == 0 ? 1 : 0);
		case ':':
			var v = pop();
			push(v);
			push(v);
		case '$', 'S':
			pop();
		case '+', '-', '*', '/', '%', '`', '\\', 'g':
			var y = pop();
			var x = pop();
			switch (c) {
			case '+':
				push(x + y);
			case '-':
				push(x - y);
			case '*':
				push(x * y);
			case '/':
				push(Std.int(x / y));
			case '%':
				push(x % y);
			case '`':
				push (x > y ? 1 : 0);
			case '\\':
				push(y);
				push(x);
			case 'g':
				push(code[y][x].charCodeAt(0));
			}
		case 'p':
			var y = pop();
			var x = pop();
			var v = pop();
			code[y][x] = String.fromCharCode(v);
		default:
		}
		return true;
	}
	function move() {
		pc.addWay(pcv);
		if (pc.x < 0) pc.x = size.x - 1;
		if (pc.x >= size.x) pc.x = 0;
		if (pc.y < 0) pc.y = size.y - 1;
		if (pc.y >= size.y) pc.y = 0;
	}
	function push(v:Int):Void {
		stack.push(v);
	}
	function pop():Int {
		if (stack.length <= 0) return 0;
		return stack.pop();
	}
}
class V {
	static var ways = [[1, 0], [0, 1], [ -1, 0], [0, -1]];
	public var x = 0;
	public var y = 0;
	public function new(x:Int = 0, y:Int = 0) {
		this.x = x;
		this.y = y;
	}
	public function addWay(w:Int) {
		x += ways[w][0];
		y += ways[w][1];
	}
}