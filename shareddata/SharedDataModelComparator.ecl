rule RepositoryRule
	match l : original!Repository with r : reconstructed!Repository {
	compare : l.name = r.name
}
rule DataAccessorRule
	match l : original!DataAccessor with r : reconstructed!DataAccessor {
	compare : l.name = r.name
}
rule DataReadRule
	match l :  original!DataRead with r : reconstructed!DataRead {
	compare :  l.dataRead = r.dataRead and l.da.matches(r.da) and l.rp.matches(r.rp)
}

rule DataWriteRule
	match l :  original!DataWrite with r : reconstructed!DataWrite {
	compare :  l.dataWrite = r.dataWrite and l.da.matches(r.da) and l.rp.matches(r.rp)
}
post {
var matchedElements = new Set;
var originalUnmatchedElements = new Set;
var reconstructedUnmatchedElements = new Set;

for (matched in matchTrace.getMatches()) {
	if(matched.matching){
		matchedElements.add(matched.left.extract());
	}
}
for (matched in matchTrace.getMatches()){
	if(not matched.matching){
		var originalUnmatched = matched.left.extract();
		var reconstructedUnmatched = matched.right.extract();
		if(not matchedElements.contains(originalUnmatched)){
			originalUnmatchedElements.add(originalUnmatched);
		}
		if(not matchedElements.contains(reconstructedUnmatched)){
			reconstructedUnmatchedElements.add(reconstructedUnmatched);
		}
	}
}

('There are: ' + matchedElements.size() + ' matched elements').println();
('There are: ' + originalUnmatchedElements.size() + ' unmatched elements in original architecture that are not present in reconstructed architecture').println();
('There are: ' + reconstructedUnmatchedElements.size() + ' unmatched elements in reconstructed architecture that are not present in original architecture').println();
var i = 1;
if(not matchedElements.isEmpty()){
	'Matched Elements'.println();
	for(matched in matchedElements) {
		(i + ". "+ matched).println();
		i = i + 1;
	}
}
i = 1;
if(not originalUnmatchedElements.isEmpty()){
	'Unmatched elements from original architecture model'.println();
	for(untmatched in originalUnmatchedElements) {
		(i + ". "+ untmatched).println();
		i = i + 1;
	}
}
i = 1;
if(not reconstructedUnmatchedElements.isEmpty()){
	'Unmatched elements from reconstructed architecture model'.println();
	for(untmatched in reconstructedUnmatchedElements) {
		(i + ". "+ untmatched).println();
		i = i + 1;
	}
}
}

operation Any extract():String {
	if(self.eClass().name == "Repository"){
		return "Repository " + self.name;
	}else if(self.eClass().name == "DataAccessor"){
		return "Data Accessor " + self.name;
	}else if(self.eClass().name == "DataRead"){
		return self.dataRead + " reads data using " + self.da.name + " from the repository " + self.rp.name ;
	}else if(self.eClass().name == "DataWrite"){
		return self.dataWrite + " writes data using " + self.da.name + " from the repository " + self.rp.name ;
	}
	return "unknown";
}