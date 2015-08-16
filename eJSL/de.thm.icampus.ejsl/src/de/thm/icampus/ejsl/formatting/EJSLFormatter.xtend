/*
 * generated by Xtext
 */
package de.thm.icampus.ejsl.formatting

import com.google.inject.Inject
import de.thm.icampus.ejsl.services.EJSLGrammarAccess
import org.eclipse.xtext.formatting.impl.AbstractDeclarativeFormatter
import org.eclipse.xtext.formatting.impl.FormattingConfig
import org.eclipse.xtext.Keyword
import org.eclipse.xtext.util.Pair
/**
 * This class contains custom formatting description.
 * 
 * see : http://www.eclipse.org/Xtext/documentation.html#formatting
 * on how and when to use it 
 * 
 * Also see {@link org.eclipse.xtext.xtext.XtextFormattingTokenSerializer} as an example
 */
class EJSLFormatter extends AbstractDeclarativeFormatter {

@Inject extension EJSLGrammarAccess

	override protected void configureFormatting(FormattingConfig c) {
		c.setAutoLinewrap(120)
		c.setWrappedLineIndentation(1)
		
		c.setLinewrap(0, 1, 2).before(SL_COMMENTRule)
		c.setLinewrap(0, 1, 2).before(ML_COMMENTRule)
		c.setLinewrap(0, 1, 1).after(ML_COMMENTRule)

		for (Pair<Keyword, Keyword> pair : findKeywordPairs("{", "}")) {
			c.setIndentation(pair.getFirst(), pair.getSecond())

			/* Linebreaks (Java style) */
			c.setLinewrap(0).before(pair.getFirst())
			c.setLinewrap(1).after(pair.getFirst())
			c.setLinewrap(1).before(pair.getSecond())
			c.setLinewrap(1, 1, 1).after(pair.getSecond())    // Linewrap must be (1,1,1) or else there will be some white lines before the }-keyword
		}

		/* Whitespace after ":" and "," but not before */
		for (Keyword k : findKeywords(":")) {
			c.setNoSpace.before(k)
		}
		for (Keyword k : findKeywords(",")) {
			c.setNoSpace.before(k)
		}

		/* The following rules are needed for line wrapping after key = value
		 * and key: value assignments. There is no generic way to do this w/o
		 * a keyword after each assignment. If a comma was used (as is the case
		 * with datatype declarations, these rules would not be necessary or
		 * could be simplified at least. */

		/* EJSLModel rule */
		/* datatypes */
		c.setLinewrap(1).after(EJSLModelAccess.commaKeyword_4_3_0)

		/* Parameter rule */
		c.setLinewrap(1).after(parameterAccess.dtypeTypeParserRuleCall_6_0)
		c.setLinewrap(1).after(parameterAccess.defaultvalueSTRINGTerminalRuleCall_7_2_0)
		c.setLinewrap(1).after(parameterAccess.labelSTRINGTerminalRuleCall_8_2_0)
		c.setLinewrap(1).after(parameterAccess.descriptonSTRINGTerminalRuleCall_10_2_0)
		c.setLinewrap(1).after(parameterAccess.labelSTRINGTerminalRuleCall_8_2_0)

		/* Attribute rule */
	//	c.setLinewrap(1).after(attributeAccess.typeAssignment_4)

		/* Reference rule */
		//c.setLinewrap(1).after(referenceAccess.entityEntityCrossReference_5_0)
		//c.setLinewrap(1).after(referenceAccess.lowerNUMBERParserRuleCall_7_0)
		//c.setLinewrap(1).after(referenceAccess.upperNUMBERParserRuleCall_9_0)

		/* Author rule */
		c.setLinewrap(1).after(authorAccess.authoremailSTRINGTerminalRuleCall_4_2_0)
		c.setLinewrap(1).after(authorAccess.authorurlSTRINGTerminalRuleCall_5_2_0)

		/* Position rule */
		c.setLinewrap(1).after(positionParameterAccess.dividIDTerminalRuleCall_3_2_0)
		c.setLinewrap(1).after(positionParameterAccess.typePOSITION_TYPES_NAMESTerminalRuleCall_4_2_0)

		/* Page rules */
		/* Static */
//		c.setLinewrap(1).before(staticPageAccess.localparametersKeyword_5_0)
//		/* Dynamic, Index */
//		c.setLinewrap(1).before(indexPageAccess.globalparametersKeyword_5_0)
//		c.setLinewrap(1).before(indexPageAccess.localparametersKeyword_6_0)
//		/* Dynamic, Details */
//		c.setLinewrap(1).before(detailsPageAccess.globalparametersKeyword_5_0)
//		c.setLinewrap(1).before(detailsPageAccess.localparametersKeyword_6_0)

		/* Manifestation rule */
		c.setLinewrap(1).after(manifestationAccess.creationdateDATETerminalRuleCall_5_2_0)
		c.setLinewrap(1).after(manifestationAccess.copyrightSTRINGTerminalRuleCall_6_2_0)
		c.setLinewrap(1).after(manifestationAccess.licenseSTRINGTerminalRuleCall_7_2_0)
		c.setLinewrap(1).after(manifestationAccess.linkSTRINGTerminalRuleCall_8_2_0)
		c.setLinewrap(1).after(manifestationAccess.versionSTRINGTerminalRuleCall_9_2_0)
		c.setLinewrap(1).after(manifestationAccess.descriptionSTRINGTerminalRuleCall_10_2_0)
		
		/* KeyValuePair rule */
		c.setLinewrap(1).after(keyValuePairAccess.valueSTRINGTerminalRuleCall_4_0)
		
		
		/* 	New formatting rules SS15: 
			set a Linewrap before the following keywords (table columns, filters, dbtype, ...) 
			to set the belonging attributes under each other
		*/
		for (Keyword k : findKeywords("table columns")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("filters")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("htmltype")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("Primary attribute")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("dbtype")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("lower")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("upper")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("Attribute")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("*Entity")) {
			c.setLinewrap.before(k)
		}
		for (Keyword k : findKeywords("Reference")) {
			c.setLinewrap.before(k)
		}
		
		
	}
}
