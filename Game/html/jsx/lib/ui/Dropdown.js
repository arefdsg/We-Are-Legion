define(['lodash', 'react', 'react-bootstrap', 'ui/Item'], function(_, React, ReactBootstrap, Item) {
    var DropdownButton = ReactBootstrap.DropdownButton;

    return React.createClass({
        mixins: [],
                
        getInitialState: function() {
            return {
                value: this.props.value,
            };
        },

        onSelect: function(item) {
            console.log(item.props.value);
        },
        
        render: function() {
            var self = this;

            var style = _.assign({}, {'pointer-events':'auto'}, this.props.style);

            return (
                <div style={style}>
                    <DropdownButton title={this.state.value}>
                        {_.map(this.props.choices, function(choice) { return (
                            <Item value={choice.value} name={choice.name} onSelect={self.onSelect}/>
                        );})}
                    </DropdownButton>
                </div>
            );
        },
    });
});