Class {
	#name : #MygToploPaging,
	#superclass : #Object,
	#category : #'Myg-Bomberman-Toplo'
}

{ #category : #'as yet unclassified' }
MygToploPaging class >> buttonPaging [

	| aNotebook manager scrollbar |
	aNotebook := ToNotebook new
		             background: Color lightRed darker;
		             margin: (BlInsets all: 50).
	manager := MygSkGameManager notebook: aNotebook.

	scrollbar := BlVerticalScrollbarElement new.
	scrollbar
		constraintsDo: [ :c | c margin: (BlInsets right: 5) ];
		attachTo: aNotebook.

	aNotebook
		addPageTitle: '1vs1'
		bodyFactory: [ self pagingPack: 'mazesLoma' managedBy: manager ];
		addPageTitle: '4 players'
		bodyFactory: [ self pagingPack: 'mazesUAlberta' managedBy: manager ].

	^ aNotebook
]

{ #category : #'accessing - structure variables' }
MygToploPaging class >> buttonWithPack: aPack withManager: aManager andIndex: i [

	| stream container button |
	stream := String streamContents: [ :out |
		          out
			          nextPutAll: 'Level ';
			          print: i ].
		
	container := BlElement new layout: BlFrameLayout new; size: 150@150 ; addChild: (self previewForButtonWithPack: aPack at: i) .
	button := ToButton new beVertical
		          iconImage: container;
		          labelText: stream;
		          constraintsDo: [ :c |
			          c horizontal matchParent.
			          c frame vertical alignCenter.
			          c frame horizontal alignCenter ];
		          whenClickedDo: [
			          | string |
			          string := (MygSkGameManager perform: aPack asSymbol) at:
					                    i.
			          aManager
				          launchFromString: string
				          inDictionary: aPack
				          at: i ].
	^ button
]

{ #category : #'as yet unclassified' }
MygToploPaging class >> pagingPack: aPack managedBy: aManager [

	| grid bigContainer root scrollbar |
	bigContainer := BlElement new
		                constraintsDo: [ :c |
			                c horizontal matchParent.
			                c vertical matchParent ];
		                yourself.
	grid := BlElement new
		        layout: (BlGridLayout horizontal
				         columnCount: 5;
				         cellSpacing: 10);
		        constraintsDo: [ :c |
			        c horizontal matchParent.
			        c vertical fitContent ].

	1 to: "(MygSkGameManager perform: aPack asSymbol) size" 10 do: [ :i |
		grid addChild: (self buttonWithPack: aPack withManager: aManager andIndex: i ) as: i asString ].

	root := grid asScrollableElement.

	scrollbar := BlVerticalScrollbarElement new
		             constraintsDo: [ :c |
			             c ignoreByLayout.
			             c margin: (BlInsets right: 2).
			             c ignored horizontal alignRight.
			             c ignored vertical alignBottom ];
		             attachTo: root.
	bigContainer addChildren: {
			root.
			scrollbar }.
	^ bigContainer
]

{ #category : #'as yet unclassified' }
MygToploPaging class >> previewForButtonWithPack: aPack at: i [

	| iconImage string board space elt |
	iconImage := MygSkBoardElement new.
	space := BlSpace new extent: 150 @ 150.
	space root addChild: iconImage.

	string := (MygSkGameManager perform: aPack asSymbol) at: i.
	board := MygSkBoard createWithBoard:
		         (MygSkGameManager importFromString: string).
	iconImage boardPreview: board.
	iconImage parent: nil.
	elt := BlElement new
		       background: Color purple;
		       size: 150 @ 150.
	^ iconImage
]

{ #category : #'see class side' }
MygToploPaging >> seeClassSide [

	
]
