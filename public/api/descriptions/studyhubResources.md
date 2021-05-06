<a name="studyhubResources"></a>A **Studyhub Resource** is a resource in terms of a clinical or epidemiological study, describing either a study or a supplementary resource (document or instrument, e.g. a questionnaire, a pdf etc.).

A **Studyhub Resource** has the following associated information:

* The **resource_type** of Studyhub Resource ("study" and "document" or "instrument", respectively)
* A **resource_json** attribute that contains all of the actual resource information as:
    * **type**, **general type**, **source**, **language** and **license information** of the resource
    * **study design information**, if the resource is of type "study"
    * arrays listing **acronyms**, **titles**, **descriptions**, **contacts**, and **related IDs** associated with **Studyhub Resource**
* **Process-related information** (e.g. wether to show in SEEK, nfdi_person_in_charge,..)
* The sharing <a href="#Policy">**Policy**</a> of the **Studyhub Resource**
* References to the <a href="#people">**People**/**Process**</a> who created the **Studyhub Resource** in SEEK
* A response for a **Studyhub Resource** such as that for a <a href="#create">**Create**</a>, <a href="#read">**Read**</a> or <a href="#update">**Update**</a> includes the additional information
* A reference to the <a href="#people">**Person**</a> who registered (submitted) the **Studyhub Resource** into SEEK
* References to the <a href="#projects">**Projects**</a> that indirectly contain the **Studyhub Resource**
* References to the <a href="#assays">**Resources**</a> that belong to the **Studyhub Resource**
* References to <a href="#dataFiles">**DataFiles**</a> that belong to the **Studyhub Resource**
* References to <a href="#documents">**Documents**</a> that belong to the **Studyhub Resource**
* References to <a href="#models">**Models**</a> that belong to the **Studyhub Resource**
* References to <a href="#sops">**Sops**</a> that belong to the **Studyhub Resource**
* References to <a href="#publications">**Publications**</a> that belong to the **Studyhub Resource**