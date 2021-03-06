//
//  Parser.swift
//  Covfefe
//
//  Created by Palle Klewitz on 19.09.17.
//  Copyright (c) 2017 Palle Klewitz
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation


/// A syntax tree with non-terminal keys and string range leafs.
public typealias ParseTree = SyntaxTree<NonTerminal, Range<String.Index>>

/// A parser which can check if a word is in a language
/// and generate a syntax tree explaining how a word was derived from a grammar
public protocol Parser {
	/// Creates a syntax tree which explains how a word was derived from a grammar
	///
	/// - Parameter string: Input word, for which a parse tree should be generated
	/// - Returns: A syntax tree explaining how the grammar can be used to derive the word described by the given tokenization
	/// - Throws: A syntax error if the word is not in the language recognized by the parser
	func syntaxTree(for string: String) throws -> ParseTree
}

public extension Parser {
	/// Returns true if the recognized language contains the given tokenization.
	///
	/// - Parameter string: Word for which membership to the recognized grammar should be decided.
	/// - Returns: True, if the word is generated by the grammar, false if not.
	public func recognizes(_ string: String) -> Bool {
		return (try? self.syntaxTree(for: string)) != nil
	}
}

/// A parser that can parse ambiguous grammars and retrieve every possible syntax tree
public protocol AmbiguousGrammarParser: Parser {
	/// Generates all syntax trees explaining how a word can be derived from a grammar.
	///
	/// This function should only be used for ambiguous grammars and if it is necessary to
	/// retrieve all parse trees, as it comes with an additional cost in runtime.
	///
	/// For unambiguous grammars, this function should return the same results as `syntaxTree(for:)`.
	///
	/// - Parameter string: Input word, for which all parse trees should be generated
	/// - Returns: All syntax trees which explain how the input was derived from the recognized grammar
	/// - Throws: A syntax error if the word is not in the language recognized by the parser
	func allSyntaxTrees(for string: String) throws -> [ParseTree]
}
