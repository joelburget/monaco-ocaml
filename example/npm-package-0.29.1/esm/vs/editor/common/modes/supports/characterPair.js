/*---------------------------------------------------------------------------------------------
 *  Copyright (c) Microsoft Corporation. All rights reserved.
 *  Licensed under the MIT License. See License.txt in the project root for license information.
 *--------------------------------------------------------------------------------------------*/
import { StandardAutoClosingPairConditional } from '../languageConfiguration.js';
export class CharacterPairSupport {
    constructor(config) {
        if (config.autoClosingPairs) {
            this._autoClosingPairs = config.autoClosingPairs.map(el => new StandardAutoClosingPairConditional(el));
        }
        else if (config.brackets) {
            this._autoClosingPairs = config.brackets.map(b => new StandardAutoClosingPairConditional({ open: b[0], close: b[1] }));
        }
        else {
            this._autoClosingPairs = [];
        }
        if (config.colorizedBracketPairs) {
            this._colorizedBracketPairs = config.colorizedBracketPairs.map(b => [b[0], b[1]]);
        }
        else if (config.brackets) {
            this._colorizedBracketPairs = config.brackets
                .map((b) => [b[0], b[1]])
                // Many languages set < ... > as bracket pair, even though they also use it as comparison operator.
                // This leads to problems when colorizing this bracket, so we exclude it by default.
                // Languages can still override this by configuring `colorizedBracketPairs`
                // https://github.com/microsoft/vscode/issues/132476
                .filter((p) => !(p[0] === '<' && p[1] === '>'));
        }
        else {
            this._colorizedBracketPairs = [];
        }
        if (config.__electricCharacterSupport && config.__electricCharacterSupport.docComment) {
            const docComment = config.__electricCharacterSupport.docComment;
            // IDocComment is legacy, only partially supported
            this._autoClosingPairs.push(new StandardAutoClosingPairConditional({ open: docComment.open, close: docComment.close || '' }));
        }
        this._autoCloseBefore = typeof config.autoCloseBefore === 'string' ? config.autoCloseBefore : CharacterPairSupport.DEFAULT_AUTOCLOSE_BEFORE_LANGUAGE_DEFINED;
        this._surroundingPairs = config.surroundingPairs || this._autoClosingPairs;
    }
    getAutoClosingPairs() {
        return this._autoClosingPairs;
    }
    getAutoCloseBeforeSet() {
        return this._autoCloseBefore;
    }
    static shouldAutoClosePair(autoClosingPair, context, column) {
        // Always complete on empty line
        if (context.getTokenCount() === 0) {
            return true;
        }
        const tokenIndex = context.findTokenIndexAtOffset(column - 2);
        const standardTokenType = context.getStandardTokenType(tokenIndex);
        return autoClosingPair.isOK(standardTokenType);
    }
    getSurroundingPairs() {
        return this._surroundingPairs;
    }
    getColorizedBrackets() {
        return this._colorizedBracketPairs;
    }
}
CharacterPairSupport.DEFAULT_AUTOCLOSE_BEFORE_LANGUAGE_DEFINED = ';:.,=}])> \n\t';
