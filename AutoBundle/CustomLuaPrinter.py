from luaparser.astnodes import *
from luaparser.utils.visitor import *
from textwrap import indent
from multimethod import multimethod


class MakuluLuaPrinter:
    def __init__(self, indent_size: int):
        self._indent_size = indent_size
        self._level = 0

    def do_visit(self, node: Node) -> str:
        if isinstance(node, Expression) and node.wrapped:
            return "(" + self.visit(node) + ")"
        return self.visit(node)

    @multimethod
    def visit(self, node: Chunk) -> str:
        return self.do_visit(node.body)

    @visit.register
    def visit(self, node: Block) -> str:
        self._level += 1
        output = indent(
            "\n".join([self.do_visit(n) for n in node.body]), "\t" * (self._indent_size if self._level > 1 else 0)
        )
        self._level -= 1
        return output

    @visit.register
    def visit(self, node: str) -> str:
        return node

    @visit.register
    def visit(self, node: float) -> str:
        return str(node)

    @visit.register
    def visit(self, node: int) -> str:
        return str(node)

    @visit.register
    def visit(self, node: list) -> str:
        return ", ".join([self.do_visit(n) for n in node])

    @visit.register
    def visit(self, node: None) -> str:
        return ""

    @visit.register
    def visit(self, node: Assign) -> str:
        return self.do_visit(node.targets) + " = " + self.do_visit(node.values)

    @visit.register
    def visit(self, node: LocalAssign) -> str:
        res = self.do_visit(node.values)
        if res == '':
            return "local " + self.do_visit(node.targets)
        return "local " + self.do_visit(node.targets) + " = " + res

    @visit.register
    def visit(self, node: While) -> str:
        return (
                "while " + self.do_visit(node.test) + " do\n" + self.do_visit(node.body) + "\nend"
        )

    @visit.register
    def visit(self, node: Do) -> str:
        return "do\n" + self.do_visit(node.body) + "\nend"

    @visit.register
    def visit(self, node: If) -> str:
        output = (
                "if " + self.do_visit(node.test) + " then\n" + self.do_visit(node.body)
        )
        if isinstance(node.orelse, ElseIf):
            output += "\n" + self.do_visit(node.orelse)
        elif node.orelse:
            output += "\nelse\n" + self.do_visit(node.orelse)
        output += "\nend"
        return output

    @visit.register
    def visit(self, node: ElseIf) -> str:
        output = (
                "elseif " + self.do_visit(node.test) + " then\n" + self.do_visit(node.body)
        )
        if isinstance(node.orelse, ElseIf):
            output += "\n" + self.do_visit(node.orelse)
        elif node.orelse:
            output += "\nelse\n" + self.do_visit(node.orelse)
        return output

    @visit.register
    def visit(self, node: Label) -> str:
        return "::" + self.do_visit(node.id) + "::"

    @visit.register
    def visit(self, node: Goto) -> str:
        return "goto " + self.do_visit(node.label)

    @visit.register
    def visit(self, node: Break) -> str:
        return "break"

    @visit.register
    def visit(self, node: Return) -> str:
        res = self.do_visit(node.values)
        if res == "False":
            return "return"
        return "return " + res

    @visit.register
    def visit(self, node: Fornum) -> str:
        output = " ".join(
            [
                "for",
                self.do_visit(node.target),
                "=",
                ", ".join([self.do_visit(node.start), self.do_visit(node.stop)]),
            ]
        )
        if node.step != 1:
            output += ", " + self.do_visit(node.step)
        output += " do\n" + self.do_visit(node.body) + "\nend"
        return output

    @visit.register
    def visit(self, node: Forin) -> str:
        return (
                " ".join(
                    ["for", self.do_visit(node.targets), "in", self.do_visit(node.iter), "do"]
                )
                + "\n"
                + self.do_visit(node.body)
                + "\nend"
        )

    @visit.register
    def visit(self, node: Call) -> str:
        return self.do_visit(node.func) + "(" + self.do_visit(node.args) + ")"

    @visit.register
    def visit(self, node: Invoke) -> str:
        return (
                self.do_visit(node.source)
                + ":"
                + self.do_visit(node.func)
                + "("
                + self.do_visit(node.args)
                + ")"
        )

    @visit.register
    def visit(self, node: Function) -> str:
        return (
                "function "
                + self.do_visit(node.name)
                + "("
                + self.do_visit(node.args)
                + ")\n"
                + self.do_visit(node.body)
                + "\nend"
        )

    @visit.register
    def visit(self, node: LocalFunction) -> str:
        return (
                "local function "
                + self.do_visit(node.name)
                + "("
                + self.do_visit(node.args)
                + ")\n"
                + self.do_visit(node.body)
                + "\nend"
        )

    @visit.register
    def visit(self, node: Method) -> str:
        return (
                "function "
                + self.do_visit(node.source)
                + ":"
                + self.do_visit(node.name)
                + "("
                + self.do_visit(node.args)
                + ")\n"
                + self.do_visit(node.body)
                + "\nend"
        )

    @visit.register
    def visit(self, node: Nil) -> str:
        return "nil"

    @visit.register
    def visit(self, node: TrueExpr) -> str:
        return "true"

    @visit.register
    def visit(self, node: FalseExpr) -> str:
        return "false"

    @visit.register
    def visit(self, node: Number) -> str:
        return self.do_visit(node.n)

    @visit.register
    def visit(self, node: String) -> str:
        if node.delimiter == StringDelimiter.SINGLE_QUOTE or node.delimiter == StringDelimiter.DOUBLE_QUOTE:
            return '"' + self.do_visit(node.s) + '"'
        else:
            return "[[" + self.do_visit(node.s) + "]]"

    @visit.register
    def visit(self, node: Table):
        output = "{\n"
        for field in node.fields:
            comment_str = ""
            if field.comments and len(field.comments) > 0:
                comment_str = " " + field.comments[0].s
            output += indent(self.do_visit(field) + "," + comment_str + "\n", "\t" * self._indent_size)
        output += "}"
        return output

    @visit.register
    def visit(self, node: Field):
        output = ""
        if not isinstance(node.key, Number) or node.key.wrapped:
            output = "[" if node.between_brackets else ""
            output += self.do_visit(node.key)
            output += "]" if node.between_brackets else ""
            output += " = "

        output += self.do_visit(node.value)
        return output

    @visit.register
    def visit(self, node: Dots) -> str:
        return "..."

    @visit.register
    def visit(self, node: AnonymousFunction) -> str:
        return (
                "function("
                + self.do_visit(node.args)
                + ")\n"
                + self.do_visit(node.body)
                + "\nend"
        )

    @visit.register
    def visit(self, node: AddOp) -> str:
        return self.do_visit(node.left) + " + " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: SubOp) -> str:
        return self.do_visit(node.left) + " - " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: MultOp) -> str:
        return self.do_visit(node.left) + " * " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: FloatDivOp) -> str:
        return self.do_visit(node.left) + " / " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: FloorDivOp) -> str:
        return self.do_visit(node.left) + " // " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: ModOp) -> str:
        return self.do_visit(node.left) + " % " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: ExpoOp) -> str:
        return self.do_visit(node.left) + " ^ " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: BAndOp) -> str:
        return self.do_visit(node.left) + " & " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: BOrOp) -> str:
        return self.do_visit(node.left) + " | " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: BXorOp) -> str:
        return self.do_visit(node.left) + " ~ " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: BShiftROp) -> str:
        return self.do_visit(node.left) + " >> " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: BShiftLOp) -> str:
        return self.do_visit(node.left) + " << " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: LessThanOp) -> str:
        return self.do_visit(node.left) + " < " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: GreaterThanOp) -> str:
        return self.do_visit(node.left) + " > " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: LessOrEqThanOp) -> str:
        return self.do_visit(node.left) + " <= " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: GreaterOrEqThanOp) -> str:
        return self.do_visit(node.left) + " >= " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: EqToOp) -> str:
        return self.do_visit(node.left) + " == " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: NotEqToOp) -> str:
        return self.do_visit(node.left) + " ~= " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: AndLoOp) -> str:
        return self.do_visit(node.left) + " and " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: OrLoOp) -> str:
        return self.do_visit(node.left) + " or " + self.do_visit(node.right)

    @visit.register
    def visit(self, node: Concat) -> str:
        return self.do_visit(node.left) + ".." + self.do_visit(node.right)

    @visit.register
    def visit(self, node: UMinusOp) -> str:
        return "-" + self.do_visit(node.operand)

    @visit.register
    def visit(self, node: UBNotOp) -> str:
        return "~" + self.do_visit(node.operand)

    @visit.register
    def visit(self, node: ULNotOp) -> str:
        return "not " + self.do_visit(node.operand)

    @visit.register
    def visit(self, node: ULengthOP) -> str:
        return "#" + self.do_visit(node.operand)

    @visit.register
    def visit(self, node: Name) -> str:
        return self.do_visit(node.id)

    @visit.register
    def visit(self, node: Index) -> str:
        if node.notation == IndexNotation.DOT:
            return self.do_visit(node.value) + "." + self.do_visit(node.idx)
        else:
            return self.do_visit(node.value) + "[" + self.do_visit(node.idx) + "]"

    @visit.register
    def visit(self, node: Varargs) -> str:
        return "..."

    @visit.register
    def visit(self, node: Repeat) -> str:
        return "repeat\n" + self.do_visit(node.body) + "\nuntil " + self.do_visit(node.test)

    @visit.register
    def visit(self, node: SemiColon) -> str:
        return ";"
