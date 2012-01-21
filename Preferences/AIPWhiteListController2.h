#import "Preferences.h"

#import "../FilteredAppListTableView/FilteredAppListTableView.h"


@interface AIPWhiteListController2 : UIViewController <FilteredAppListDelegate> {
	AlwaysiPodPlayWhiteListController *delegate;
	FilteredAppListTableView *_tableView;
}

- (id)tableView;
- (void)dealloc;

- (void)setDelegate:(id)_delegate;

- (FilteredListType)filteredListTypeForIdentifier:(NSString *)identifier;
- (void)didSelectRowAtCell:(FilteredAppListCell *)cell;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end

