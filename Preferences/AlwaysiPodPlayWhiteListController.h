/* 
 * 
 *	AlwaysiPodPlayWhiteListController.h
 *	AlwaysiPodPlay's Settings bundle
 *	
 *	
 *	Always iPod Play
 *	Copyright (C) 2011-2014  deVbug (devbug@devbug.me)
 *	
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License.
 *	 
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *	
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *	
 */


#import "Preferences.h"

#import "../FilteredAppListTableView/FilteredAppListTableView.h"


@interface AlwaysiPodPlayWhiteListController : AAPListController <FilteredAppListDelegate> {
	FilteredAppListTableView *_tableView;
}

- (id)tableView;
- (void)dealloc;

- (FilteredListType)filteredListTypeForIdentifier:(NSString *)identifier;
- (void)didSelectRowAtCell:(FilteredAppListCell *)cell;

@end

