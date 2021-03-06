package de.thm.icampus.joomdd.ejsl.generator.pi.ExtendedEntity

import de.thm.icampus.joomdd.ejsl.eJSL.Entity
import org.eclipse.emf.common.util.EList
import de.thm.icampus.joomdd.ejsl.eJSL.Attribute
import de.thm.icampus.joomdd.ejsl.eJSL.Reference

/**
 * This interface defines methods, which are needed to access further information on an Entity.
 * 
 * @see Entity
 */
interface ExtendedEntity extends Entity {
	
	def void setParentProperties(Entity entity)
	
	/**
	 * Returns all defined ExtendedAttributes on this ExtendedEntity.
	 * 
	 * @return list of own ExtendedAttributes
	 */
	def EList<ExtendedAttribute> getOwnExtendedAttributes()
	
	/**
	 * Returns all defined ExtendedAttributes on the parent ExtendedEntity.
	 * 
	 * @return list of own ExtendedAttributes
	 */
	def EList<ExtendedAttribute> getParentExtendedAttributes()
	
	/**
	 * Returns the instance of Entity, which is extended by this class.
	 * 
	 * @return instance of Entity
	 */
	def Entity getInstance()
	
	/**
	 * Returns all ExtendedAttribute instances belonging to this.
	 * 
	 * @return list of belonging ExtendedAttribute instances
	 */
	def EList<ExtendedAttribute> getAllExtendedAttributes()
	
	/**
	 * Returns all ExtendedReference instances belonging to this.
	 * 
	 * @return list of belonging ExtendedReference instances
	 */
	def EList<ExtendedReference> getAllExtendedReferences()
	
	/**
	 * Returns whether this has an attribute to identify itself
	 * 
	 * @return whether this has an ID attribute
	 */
	def boolean hasIdAttribute()
	
	/**
	 * Returns all ExtendedReference instances, which are connected to only this instance.
	 * 
	 * @return list of ExtendReference instances
	 */
	def EList<ExtendedReference>getAllExtendedReferencesToEntity()
	
	/**
	 * Searches and returns an ExtendedAttribute specified by its name. 
	 * 
	 * @param name String to specify name of ExtendedAttribute
	 * @return ExtendedAttribute specified by name, null if not available
	 */
	def ExtendedAttribute getExtendedAttributeByName(String name)
	
	/**
	 * TODO
	 */
	def EList<ExtendedAttribute> getAllRefactoryAttribute()
	
	/**
	 * TODO
	 */
	def EList<ExtendedReference>getAllRefactoryReference()
	
	/**
	 * TODO
	 */
	def boolean isGenerated()
	
	/**
	 * Returns the primary key attribute of this
	 * 
	 * @return the primary ExtendedAttribute
	 */
	def ExtendedAttribute getPrimaryKey()
	
	/**
	 * Returns the first  unique key attribute of this
	 * 
	 * @return the unique  ExtendedAttribute
	 */
	def ExtendedAttribute getFirstUniqueKey()
	
	def ExtendedReference searchRefWithAttr(Attribute attribute, Entity entity)
	
	def EList<ExtendedReference> searchListRefWithAttr(Attribute attribute)
	
	def boolean getIsMappingEntity()
}