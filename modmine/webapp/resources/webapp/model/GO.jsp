<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="im" %>

<table width="100%">
  <tr>
    <td valign="top">
      <div class="heading2">
        Current data
      </div>
      <div class="body">

 <h4>
   <a href="javascript:toggleDiv('hiddenDiv1');">
    <img id='hiddenDiv1Toggle' src="images/disclosed.gif"/>
    GO annotation in modENCODEMine ...
   </a>
 </h4>

<div id="hiddenDiv1" class="dataSetDescription">
      <p>
      The Gene Ontology project provides a controlled vocabulary to describe 
      gene and gene product attributes in any organism.  The GO collaborators 
      are developing three structured, controlled vocabularies (ontologies) 
      that describe gene products in terms of their associated biological 
      processes, cellular components and molecular functions in a species-independent manner.
      </p>
      <p>
      modENCODEMine has GO annotations for <i>Drosophila</i> and
      <i>C. elegans</i>.
<%--
  GO annotation for
      other organisms is also included and is accessible via orthologues.
--%>
      </p>      
        <ul>
         <li><i>D. melanogaster</i> - GO annotations for <i>D. melanogaster</i> gene products assigned by <a href="http://www.ebi.ac.uk/GOA/" target="_new">FlyBase</a></li><br/>
         <li><i>C. elegans</i> - GO annotations for <i>C. elegans</i> gene products assigned by <a href="http://www.wormbase.org" target="_new">WormBase</a>.</li><br/>
<%--
         <li><i>A. gambiae</i> - GO annotations for <i>A. gambiae</i> gene products assigned by the <a href="http://www.ebi.ac.uk/GOA/" target="_new">GO annotation@EBI</a> project.</li><br/>
         <li><i>S. cerevisiae</i> - GO annotations for <i>S. cerevisiae</i> gene products assigned by <a href="http://www.yeastgenome.org/" target="_new">SGD</a>.</li><br/>
         <li><i>M. musculus</i> - GO annotations for <i>M. musculus</i> gene products assigned by <a href="http://www.informatics.jax.org" target="_new">MGI</a>.</li><br/>
--%>
       </ul>
      </div>


 <h4>
   <a href="javascript:toggleDiv('hiddenDiv2');">
    <img id='hiddenDiv2Toggle' src="images/disclosed.gif"/>
    GO Evidence Codes ...
   </a>
 </h4>

<div id="hiddenDiv2"  class="dataSetDescription">

      <p> Every GO annotation indicates the type of evidence that
      supports it; these evidence codes correspond to broad categories
      of experimental or other support. The codes are listed below. For more
      information, go to <a href="http://www.geneontology.org/GO.evidence.shtml" target="_new">Guide to GO Evidence Codes</a>. </p>
      <p> IC = Inferred by Curator </p> 
      <p> IDA = Inferred from Direct Assay </p> 
      <p> IEA = Inferred from Electronic Annotation </p> 
      <p> IEP = Inferred from Expression Pattern </p> 
      <p> IGI = Inferred from Genetic Interaction </p> 
      <p> IMP = Inferred from Mutant Phenotype </p> 
      <p> IPI = Inferred from Physical Interaction </p> 
      <p> ISS = Inferred from Sequence or Structural Similarity </p> 
      <p> NAS = Non-traceable Author Statement </p> 
      <p> ND = No biological Data available </p> 
      <p> RCA = inferred from Reviewed Computational Analysis </p> 
      <p> TAS = Traceable Author Statement </p> 
      <p> NR = Not Recorded  </p> 
     <br/>
    </div>



 <h4>
   <a href="javascript:toggleDiv('hiddenDiv3');">
    <img id='hiddenDiv3Toggle' src="images/disclosed.gif"/>
    GO Qualifiers ...
   </a>
 </h4>

<div id="hiddenDiv3"  class="dataSetDescription">

      <p> The Qualifier column is used for flags that modify the
      interpretation of an annotation. Allowable values are
      'contributes_to', 'colocalizes_with' and 'NOT'.
      'colocalizes_with' is used only with cellular component terms. 
      'contributes_to' is used only with molecular function terms.
      'NOT' is used with terms from any of the three ontologies. </p>
     </div>
    </div>
   </td>



    <td width="40%" valign="top">
      <div class="heading2">
        Bulk download
      </div>
      <div class="body">
        <ul>

          <li>
            <im:querylink text="All gene/GO annotation pairs from <i>D. melanogaster</i> " skipBuilder="true">
             <query name="" model="genomic" view="Gene.identifier Gene.primaryIdentifier Gene.symbol Gene.goAnnotation.identifier Gene.goAnnotation.name">
              <node path="Gene" type="Gene">
               </node>
              <node path="Gene.organism" type="Organism">
               </node>
              <node path="Gene.organism.name" type="String">
              <constraint op="=" value="Drosophila melanogaster" description="" identifier="" code="A">
             </constraint>
              </node>
           </query>
          </im:querylink>
         </li>
<%--
         <li>
           <im:querylink text="All gene/GO annotation pairs from <i>A. gambiae</i> " skipBuilder="true">
            <query name="" model="genomic" view="Gene.identifier Gene.primaryIdentifier Gene.symbol Gene.annotations.identifier Gene.annotations.name">
             <node path="Gene" type="Gene">
              </node>
             <node path="Gene.organism" type="Organism">
              </node>
             <node path="Gene.organism.name" type="String">
             <constraint op="=" value="Anopheles gambiae str. PEST" description="" identifier="" code="A">
            </constraint>
           </node>
            <node path="Gene.annotations" type="GOAnnotation">
           </node>
          </query>
         </im:querylink>
        </li>
--%>
        <li>
         <im:querylink text="All GO Term identifiers with names and descriptions " skipBuilder="true">
          <query name="" model="genomic" view="GOTerm.identifier GOTerm.name GOTerm.description">
           </query>
         </im:querylink>
        </li>

       </ul>
      </div>
    </td>
  </tr>
</table>
