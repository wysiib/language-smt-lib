describe 'SMT-LIB grammar', ->
  grammar = null

  beforeEach ->
    waitsForPromise ->
      atom.packages.activatePackage('language-smt-lib')

    runs ->
      grammar = atom.grammars.grammarForScopeName('source.smtlib')

  it 'parses the grammar', ->
    expect(grammar).toBeTruthy()
    expect(grammar.scopeName).toBe 'source.smtlib'

  describe "literals", ->
    it "tokenizes integer literals", ->
      {tokens} = grammar.tokenizeLine "(= 1 5)"
      expect(tokens[1]).toEqual value: '=', scopes: [ 'source.smtlib', 'keyword.operator.smtlib' ]
      expect(tokens[3]).toEqual value: '1', scopes: [ 'source.smtlib', 'constant.numeric.smtlib' ]
      expect(tokens[5]).toEqual value: '5', scopes: [ 'source.smtlib', 'constant.numeric.smtlib' ]

  describe "operators", ->
    it "tokenizes some arithmetic operators correctly", ->
      {tokens} = grammar.tokenizeLine "(=> (> x 15) (> x 10))"
      expect(tokens[1]).toEqual value: '=>', scopes: [ 'source.smtlib', 'keyword.operator.smtlib' ]
      expect(tokens[4]).toEqual value: '>', scopes: [ 'source.smtlib', 'keyword.operator.smtlib' ]
      expect(tokens[6]).toEqual value: 'x', scopes: [ 'source.smtlib', 'identifier.smtlib' ]
      expect(tokens[8]).toEqual value: '15', scopes: [ 'source.smtlib', 'constant.numeric.smtlib' ]
      expect(tokens[12]).toEqual value: '>', scopes: [ 'source.smtlib', 'keyword.operator.smtlib' ]
      expect(tokens[14]).toEqual value: 'x', scopes: [ 'source.smtlib', 'identifier.smtlib' ]
      expect(tokens[16]).toEqual value: '10', scopes: [ 'source.smtlib', 'constant.numeric.smtlib' ]

  describe "comments", ->
    it "tokenizes an empty comment", ->
      {tokens} = grammar.tokenizeLine ';'
      expect(tokens[0]).toEqual value: ';', scopes: [  'source.smtlib', 'comment.line.semicolon.smtlib', 'punctuation.definition.comment.smtlib' ]

    it "tokenizes a comment", ->
      {tokens} = grammar.tokenizeLine '; this is my comment'
      expect(tokens[0]).toEqual value: ';', scopes: [ 'source.smtlib', 'comment.line.semicolon.smtlib', 'punctuation.definition.comment.smtlib' ]
      expect(tokens[1]).toEqual value: ' this is my comment', scopes: [ 'source.smtlib', 'comment.line.semicolon.smtlib' ]
