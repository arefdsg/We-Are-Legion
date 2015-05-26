define(['lodash', 'react', 'react-bootstrap', 'interop', 'events', 'ui', 'Components/Chat'], function(_, React, ReactBootstrap, interop, events, ui, Chat) {
    var Panel = ReactBootstrap.Panel;
    var Button = ReactBootstrap.Button;
    var Well = ReactBootstrap.Well;
    var Popover = ReactBootstrap.Popover;
    var Table = ReactBootstrap.Table;
    var ListGroup = ReactBootstrap.ListGroup;
    var ListGroupItem = ReactBootstrap.ListGroupItem;
    
    var Div = ui.Div;
    var Gap = ui.Gap;
    var UiImage = ui.UiImage;
    var UiButton = ui.UiButton;
    var Dropdown = ui.Dropdown;
    var OptionList = ui.OptionList;
    var RenderAtMixin = ui.RenderAtMixin;
    
    var pos = ui.pos;
    var size = ui.size;
    var width = ui.width;
    var subImage = ui.subImage;

    var GameItem = React.createClass({
        mixin: [],

        getInitialState: function() {
            return {
            };
        },
        
        onClick: function() {
            setScreen('game-lobby', {
                host: false,
                lobbyIndex: this.props.data.Index,
            });
        },

        render: function() {
            return (
                <tr>
                    <td>{this.props.data.Name}</td>
                    <td>{this.props.data.Name}</td>
                    <td>{this.props.data.Name}</td>
                    <td>
                        <Button onClick={this.onClick}>
                            Join
                        </Button>
                    </td>
                </tr>
            );
        },
    });

    return React.createClass({
        mixins: [events.FindLobbiesMixin],

        onFindLobbies: function(values) {
            console.log('found lobbies');

            this.setState({
                loading: false,
                lobbies: values.Lobbies,
            });
        },
                
        getInitialState: function() {
            interop.findLobbies();

            return {
                loading: true,
                lobbies: [],
            };
        },
        
        render: function() {
            var _this = this;

            var visibility = [
                {name:'Public games', value:'public'},
                {name:'Friend games', value:'friend'},
            ];

            return (
                <div>
                    <Div nonBlocking pos={pos(10,5)} size={width(80)}>
                        <Panel>
                            <h2>
                                Game list
                            </h2>
                        </Panel>

                        <Well style={{'height':'75%'}}>

                            {/* Game List */}
                            <Div className='game-list' pos={pos(3.3,16.9)} size={size(50,66.2)}
                                 style={{'overflow-y':'scroll','pointer-events':'auto','font-size': '1.4%'}}>
                                {this.state.loading ? 'Loading...' :
                                    <Table style={{width:'100%','pointer-events':'auto'}}><tbody>
                                        {_.map(this.state.lobbies, function(lobby) {
                                            return <GameItem data={lobby} />;
                                        })}
                                    </tbody></Table>
                                }
                            </Div>

                            {/* Game visibility type */}
                            <Div pos={pos(55.3,16.9)} size={size(30,66.2)}>
                                <OptionList options={visibility} />
                            </Div>

                            {/* Buttons */}
                            <Div nonBlocking pos={pos(38,80)} size={width(60)}>
                                <div style={{'float':'right', 'pointer-events':'auto'}}>
                                    <p>
                                        <Button onClick={back}>Back</Button>
                                    </p>
                                </div>
                            </Div>

                        </Well>
                    </Div>
                </div>
            );
        }
    });
}); 