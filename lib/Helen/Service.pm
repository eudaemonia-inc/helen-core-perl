# Copyright (C) 2018, 2019  Eudaemonia Inc
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

package Helen::Service;
use strict;
use warnings;
use version 0.77;
our $VERSION = 'v0.0.4';

use Moose;
use namespace::autoclean;

sub authorize_helen {
  #** @method public authorize_helen (code_sub, subservice)
  #
  # @param[in] code_sub Callback to get access token
  # @param[in] subservice Optional subservice to authorize
  #
  # When Helen is being authorized to access a service on behalf of an
  # agent, this code ref is given a prompt string as an argument and
  # is expected to return a string to be stored and used as the access
  # token for the service.
  #
  # Targetprocess and Smartsheet use this to give the subject agent a
  # bearer token for itself.
  #
  # Oauth uses this to give the subject agent a code for itself.
  #
  # Google uses this to give the subject agent a client secret.
  #
  # GoogleSheets delegates this to Oauth.
  #
  # Mint needs to use this to give the subject a password.
  #
  #*
};
  
no Moose;
__PACKAGE__->meta->make_immutable;
1;
