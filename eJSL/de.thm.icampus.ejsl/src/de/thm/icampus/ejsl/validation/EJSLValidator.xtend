/*
 * generated by Xtext
 */
package de.thm.icampus.ejsl.validation
import de.thm.icampus.ejsl.eJSL.Author
import de.thm.icampus.ejsl.eJSL.BackendSection
import de.thm.icampus.ejsl.eJSL.Component
import de.thm.icampus.ejsl.eJSL.DynamicPage
import de.thm.icampus.ejsl.eJSL.EJSLModel
import de.thm.icampus.ejsl.eJSL.EJSLPackage
import de.thm.icampus.ejsl.eJSL.Entity
import de.thm.icampus.ejsl.eJSL.Extension
import de.thm.icampus.ejsl.eJSL.ExtensionPackage
import de.thm.icampus.ejsl.eJSL.Language
import de.thm.icampus.ejsl.eJSL.Library
import de.thm.icampus.ejsl.eJSL.Manifestation
import de.thm.icampus.ejsl.eJSL.Page
import de.thm.icampus.ejsl.eJSL.Section
import java.util.HashMap
import java.util.HashSet
import java.util.regex.Pattern
import java.util.Set
import org.eclipse.emf.ecore.EObject
import org.eclipse.xtext.validation.Check
import de.thm.icampus.ejsl.eJSL.Reference

/**
 * Custom validation rules. 
 *
 * see http://www.eclipse.org/Xtext/documentation.html#validation
 */
class EJSLValidator extends AbstractEJSLValidator {


	public static val AMBIGUOUS_ATTRIBUTE_NAME = 'ambiguousAttrName'
	public static val AMBIGUOUS_AUTHOR = 'ambiguousAuthor'
	public static val AMBIGUOUS_CLASS = 'ambiguousClass'
	public static val AMBIGUOUS_DATATYPE = 'ambiguousDatatype'
	public static val AMBIGUOUS_ENTITY = 'ambiguousEntity'
	public static val AMBIGUOUS_EXTENSION = 'ambiguousExt'
	public static val AMBIGUOUS_GLOBALPARAMETER = 'ambiguousGlobalparam'
	public static val AMBIGUOUS_KEY = 'ambiguousKey'
	public static val AMBIGUOUS_LANGUAGE = 'ambiguousLanguage'
	public static val AMBIGUOUS_LOCALPARAMETER = 'ambiguousLocalparam'
	public static val AMBIGUOUS_METHOD = 'ambiguousMethod'
	public static val AMBIGUOUS_PAGE = 'ambiguousPage'
	public static val ENTITY_USED_MULTIPLE_TIMES = 'entityUsedMultipleTimes'
	public static val EXTPACKAGE_CONTAINS_EXTPACKAGE = 'extPackageContainsExtPackage'
	public static val INVALID_AUTHOR_EMAIL = 'invalidAuthorEmail'
	public static val INVALID_AUTHOR_URL = 'invalidAuthorUrl'
	public static val MORE_THAN_ONE_BACKEND = 'moreThanOneBackend'
	public static val MORE_THAN_ONE_FRONTEND = 'moreThanOneFrontend'
	public static val PAGE_USED_MULTIPLE_TIMES = 'pageUsedMultipleTimes'
	public static val MISSING_PRIMARY_ATTRIBUTE = 'missingPrimaryAttribute'
	public static val NOT_PRIMARY_REFERENCE = 'notPrimaryReference'
	

	/**
	 * A domain consists of one or more domain parts. A domain part may contain
	 * any letter (Unicode), number (0-9) and dash (-) but may not start and
	 * end with a dash (constraint not checked for simplicity). Domain parts
	 * are separated by dot (.).
	 */
	public static val domainPattern = "([\\p{L}0-9-]+\\.)+[\\p{L}0-9]+"

	/**
	 * An e-mail address consists of a user and a domain part which are
	 * separated by an at-sign (@). The user part may contain any letter
	 * (Unicode), number (0-9), dot (.), dash (-), underscore (_) and plus (+).
	 */
	public static val emailPattern = Pattern.compile("[\\p{L}0-9._+-]+?@" + domainPattern)

	/**
	 * An HTTP URL consists of a scheme and a domain. The scheme is limited to
	 * http:// and https://
	 */
	public static val httpUrlPattern = Pattern.compile("https?://" + domainPattern + "(/.*)?")

	@Check
	def checkDatatypesAreUnique(EJSLModel model) {
		var types = new HashSet<String>

		for (type : model.datatypes) {
			if (!types.add(type.name)) {
				error(
					'Datatype must be unique.',
					type,
					EJSLPackage.Literals.DATATYPE__NAME,
					AMBIGUOUS_DATATYPE
				)
			}
		}
	}

	@Check
	def checkEntitiesAreUnique(EJSLModel model) {
		var entities = new HashSet<String>

		for (entity : model.entities) {
			if (!entities.add(entity.name)) {
				error(
					'Entity names must be unique.',
					entity,
					EJSLPackage.Literals.ENTITY__NAME,
					AMBIGUOUS_ENTITY
				)
			}
		}
	}

	@Check
	def checkEntityAttributesAreUnique(Entity entity) {
		var attributes = new HashSet<String>

		for (attribute : entity.attributes) {
			if (!attributes.add(attribute.name)) {
				error(
					'Attribute names must be unique.',
					attribute,
					EJSLPackage.Literals.ATTRIBUTE__NAME,
					AMBIGUOUS_ATTRIBUTE_NAME
				)
			}
		}
	}

	@Check
	def checkPagesAreUnique(EJSLModel model) {
		var pages = new HashSet<String>

		for (page : model.pages) {
			if (!pages.add(page.name)) {
				error(
					'Page names must be unique.',
					page,
					EJSLPackage.Literals.PAGE__NAME,
					AMBIGUOUS_PAGE
				)
			}
		}
	}

	@Check
	def checkComponentHasOnlyOneSectionInstancePerClass(Component component) {
		var hasBackend = false
		var hasFrontend = false

		var i = 0
		for (Section section : component.sections) {
			if (section instanceof BackendSection) {
				if (hasBackend) {
					error(
						'Component must not have more than one backend.',
						EJSLPackage.Literals.COMPONENT__SECTIONS,
						i,
						MORE_THAN_ONE_BACKEND
					)
				}
				hasBackend = true
			} else {
				if (hasFrontend) {
					error(
						'Component must not have more than one frontend.',
						EJSLPackage.Literals.COMPONENT__SECTIONS,
						i,
						MORE_THAN_ONE_FRONTEND
					)
				}
				hasFrontend = true
			}
			i++;
		}
	}

	@Check
	def checkComponentLanguageIsUnique(Extension ext) {
		var langs = new HashSet<String>

		for (lang : ext.languages) {
			if (!langs.add(lang.name)) {
				error(
					'Extension language must be unique.',
					lang,
					EJSLPackage.Literals.LANGUAGE__NAME,
					AMBIGUOUS_LANGUAGE
				)
			}
		}
	}

	@Check
	def checkLanguageKeysAreUnique(Language lang) {
		var keys = new HashSet<String>

		for (pair : lang.keyvaluepairs) {
			if (!keys.add(pair.name)) {
				error(
					'Key must be unique.',
					pair,
					EJSLPackage.Literals.KEY_VALUE_PAIR__NAME,
					AMBIGUOUS_KEY
				)
			}
		}
	}

	@Check
	def checkManifestationAuthorsAreUnique(Manifestation manifest) {
		var authors = new HashSet<String>

		for (author : manifest.authors) {
			if (!authors.add(author.name)) {
				warning(
					'Author name is used multiple times.',
					author,
					EJSLPackage.Literals.AUTHOR__NAME,
					AMBIGUOUS_AUTHOR
				)
			}
		}
	}

	@Check
	def checkLibraryClassesAreUnique(Library lib) {
		var classes = new HashSet<String>

		for (c : lib.classes) {
			if (!classes.add(c.name)) {
				error(
					'Class name must be unique per library.',
					c,
					EJSLPackage.Literals.CLASS__NAME,
					AMBIGUOUS_CLASS
				)
			}
		}
	}

	@Check
	def checkClassMethodsAreUnique(de.thm.icampus.ejsl.eJSL.Class c) {
		var methods = new HashSet<String>

		for (method : c.methods) {
			if (!methods.add(method.name)) {
				error(
					'Method name must be unique per class.',
					method,
					EJSLPackage.Literals.METHOD__NAME,
					AMBIGUOUS_METHOD
				)
			}
		}
	}
/*
	@Check
	def checkGlobalparametersAreUnique(Page p) {
		var params = new HashSet<String>

		for (param : p.localparameters) {
			if (!params.add(param.name)) {
				error(
					'Localparameter name must be unique per page.',
					param,
					EJSLPackage.Literals.PARAMETER__NAME,
					AMBIGUOUS_LOCALPARAMETER
				)
			}
		}
	}
 */ // double Code
	@Check
	def checkPageGlobalparametersAreUnique(EJSLModel model) {
		var params = new HashSet<String>

		for (param : model.globalparameters) {
			if (!params.add(param.name)) {
				error(
					'Globalparameter name must be unique.',
					param,
					EJSLPackage.Literals.PARAMETER__NAME,
					AMBIGUOUS_GLOBALPARAMETER
				)
			}
		}
	}

	@Check
	def checkPageLocalparametersAreUnique(Page p) {
		var params = new HashSet<String>

		for (param : p.localparameters) {
			if (!params.add(param.name)) {
				error(
					'Localparameter name must be unique per page.',
					param,
					EJSLPackage.Literals.PARAMETER__NAME,
					AMBIGUOUS_LOCALPARAMETER
				)
			}
		}
	}

	@Check
	def checkExtensionsAreUniquePerClass(EJSLModel model) {
		var exts = new HashMap<Class<? extends EObject>, Set<String>>

		for (ext : model.extensions) {
			var Class<? extends EObject> type = ext.class
			var Set<String> specializedExts = exts.get(type)
			if (null == specializedExts) {
				specializedExts = new HashSet<String>
				exts.put(type, specializedExts)
			}
			if (!specializedExts.add(ext.name)) {
				error(
					'Extension name must be unique for type ' + ext.class.simpleName + '.',
					ext,
					EJSLPackage.Literals.EXTENSION__NAME,
					AMBIGUOUS_EXTENSION
				)
			}
		}
	}

	@Check
	def checkExtensionPackagesDoNotContainExtensionPackages(ExtensionPackage extPackage) {
		var i = 0
		for (ext : extPackage.extensions) {
			if (ext instanceof ExtensionPackage) {
				error(
					'Extension package must not contain more extension packages.',
					EJSLPackage.Literals.EXTENSION_PACKAGE__EXTENSIONS,
					i,
					EXTPACKAGE_CONTAINS_EXTPACKAGE
				)
			}
			i++
		}
	}

	@Check
	def checkEntitysAreUsedOnlyOncePerPage(DynamicPage page) {
		var entities = new HashSet<String>

		var i = 0
		for (entity : page.entities) {
			if (!entities.add(entity.name)) {
				warning(
					'Entity is used multiple times for this page.',
					EJSLPackage.Literals.DYNAMIC_PAGE__ENTITIES,
					i,
					ENTITY_USED_MULTIPLE_TIMES
				)
			}
			i++
		}
	}

	@Check
	def checkPagesAreUsedOnlyOncePerSection(Section section) {
		var pages = new HashSet<String>

		var i = 0
		for (page : section.page) {
			if (!pages.add(page.name)) {
				warning(
					'Page is used multiple times for this section.',
					EJSLPackage.Literals.SECTION__PAGE,
					i,
					PAGE_USED_MULTIPLE_TIMES
				)
			}
			i++
		}
	}

	@Check
	def checkAuthorEmailIsValid(Author author) {
		if (!author.authoremail.isEmailAdressValid) {
			warning(
				'Invalid e-mail address. Should be in this format: xxx@xx.xx',
				EJSLPackage.Literals.AUTHOR__AUTHOREMAIL,
				INVALID_AUTHOR_EMAIL
			)
		}
	}

	@Check
	def checkAuthorUrlIsValid(Author author) {
		if (!author.authorurl.isUrlValid) {
			warning(
				'Invalid URL. Should be in this format: http(s)//:www.xxx.xx',
				EJSLPackage.Literals.AUTHOR__AUTHORURL,
				INVALID_AUTHOR_URL
			)
		}
	}

	def isEmailAdressValid(String address) {
		return emailPattern.matcher(address).matches
	}

	def isUrlValid(String url) {
		return httpUrlPattern.matcher(url).matches
	}
	
	@Check
	def checkPrimaryAttributeExist(Entity entity) {
		var hasPrimary = false;
		
		for (attribute : entity.attributes) {
			if(attribute.isIsprimary){
				hasPrimary = true;
			}
		}
		if(!hasPrimary){
			error(
					'Attributes must have a primary attribute.',
					entity,
					EJSLPackage.Literals.ENTITY__NAME,
					MISSING_PRIMARY_ATTRIBUTE
				)
		}
	}
	
	@Check
	def refToAttributeMustBePrimary(Reference reference){
		if(!reference.attributerefereced.isprimary){
			error(
				'The referenced attribute has to be a primary attribute.',
				reference,
				EJSLPackage.Literals.REFERENCE__ATTRIBUTEREFERECED,
				NOT_PRIMARY_REFERENCE
			)
		}
	}
	
	@Check
	def checkAttributename(Entity entity) {
		for (attribute : entity.attributes) {			
			if (attribute.name == "id") {				
				error(
					'\"id\" is not a valid attribute name!',
					attribute,
					EJSLPackage.Literals.ATTRIBUTE__NAME,
					AMBIGUOUS_ATTRIBUTE_NAME
				)
			}			
			if(attribute.name == "ordering"||attribute.name =="state"||attribute.name =="checked_out" ||
				attribute.name == "checked_out_time" ||attribute.name == "created_by"){ 				
				warning("Attribute name should not be: " + attribute.name +"!",
					attribute,
					EJSLPackage.Literals.ATTRIBUTE__NAME,
					AMBIGUOUS_ATTRIBUTE_NAME
				)				
			}
		}
	}	

}
