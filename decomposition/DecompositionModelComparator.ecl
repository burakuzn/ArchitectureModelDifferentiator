rule ModuleRule
	match l : original!Module with r : reconstructed!Module {
	compare : l.name = r.name and l.subelements.matches(r.subelements)
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
	if(self.eClass().name == "Module"){
		return "Module " + self.name;
	}
	return "unknown";
}
